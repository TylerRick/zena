module Zena
  module Use
    module Zazen
      module ViewMethods

        include Zena::Use::Grid::ViewMethods

        @@_asset_methods = {}

        # define an asset method ('key' => method_name).
        def self.asset_method(opts)
          opts.each do |k,v|
            @@_asset_methods[k] = v
          end
        end

        # This method renders the Textile text contained in an object as html. It also renders the zena additions :
        # === Zena additions
        # all these additions are replaced by the traduction of 'unknown link' or 'unknown image' if the user does
        # not have read access to the linked node.
        # * ["":34] creates a link to node 34 with node's title.
        # * ["title":34] creates a link to node 34 with the given title.
        # * ["":034] if the node id starts with '0', creates a popup link.
        # * [!14!] inline image 14 or link to document 14 with icon. (default format for images is 'std' defined in #ImageBuilder). Options are :
        # ** [!014!] if the id starts with '0', the image becomes a link to the full image.
        # ** [!<.14!] or [!<14!] inline image surrounded with <p class='img_left'></p>
        # ** [!>.14!] or [!>14!] inline image surrounded with <p class='img_right'></p>
        # ** [!=.14!] or [!=14!] inline image with <p class='img_center'></p>
        # ** [!14_pv!] inline image transformed to format 'pv' (class is also set to 'pv'). Formats are defined in #ImageBuilder.
        # ** all the options above can be used together as in [!>.14.med!] : inline image on the right, size 'med'.
        # ** [![2,3,5]!] gallery : inline preview with javascript inline viewer
        # ** [![]!] gallery with all images contained in the current node
        # * [!{7,9}!] documents listing for documents 7 and 9
        # * [!{}!] list all documents (with images) for the current node
        # * [!{d}!] list all documents (without images) for the current node
        # * [!{i}!] list all images for the current node
        # * [!14!:37] you can use an image as the source for a link
        # * [!14!:www.example.com] use an image for an outgoing link
        def zazen(text, opt={})
          return '' unless text
          opt = {:images=>true, :pretty_code=>true, :output=>'html'}.merge(opt)
          no_p = opt.delete(:no_p)
          img = opt[:images]
          if opt[:limit]
            opt[:limit] -= 1 unless opt[:limit] <= 0
            paragraphs = text.split(/\n\n|\r\n\r\n/)
            if paragraphs.size > (opt[:limit]+1) && opt[:limit] != -1
              text = paragraphs[0..opt[:limit]].join("\r\n\r\n") + " &#8230;"
            end
          end
          opt[:node] ||= @node
          res = ZazenParser.new(text,:helper=>self).render(opt)
          if no_p && !text.include?("\n")
            res.gsub(%r{\A<p>|</p>\Z},'')
          else
            res
          end
        end

        # TODO: test
        def zazen_diff(text1, text2, opt={})
          HTMLDiff::diff(zazen(text1), zazen(text2))
        end

        # Parse the text in the given context (used by zazen)
        def make_asset(opts)
          asset_tag = opts[:asset_tag]
          if asset_method = @@_asset_methods[asset_tag]
            self.send(asset_method, opts)
          else
            # Unknown tag. Ignore
            "[#{asset_tag}]#{opts[:content]}[/#{asset_tag}]"
          end
        end

        # Creates a link to the node referenced by zip (used by zazen)
        def make_link(opts)
          # for latex refs, see http://www.tug.org/applications/hyperref/manual.html
          link_opts = {}
          if anchor = opts[:anchor]
            if anchor =~ /\[(.+?)\/(.*)\]/
              anchor_in, anchor = $1, $2
              anchor = anchor == '' ? 'true' : "[#{anchor}]"
              link_opts[:anchor_in] = anchor_in
            end
            if ['[id]', '[zip]'].include?(anchor)
              link_opts[:anchor] = 'true'
            else
              link_opts[:anchor] = anchor
            end
          end
          if opts[:id] =~ /(\d+)(_\w+|)(\.\w+|)/
            opts[:id]     = $1
            link_opts[:mode]   = ($2 != '') ? $2[1..-1] : nil
            link_opts[:format] = ($3 != '') ? $3[1..-1] : nil
          end
          node  = opts[:node] || secure(Node) { Node.find_by_zip(opts[:id]) }

          return "<span class='unknownLink'>#{_('unknown link')}</span>" unless node

          title = (opts[:title] && opts[:title] != '') ? opts[:title] : node.version.title

          link_opts[:format] = node.c_ext if link_opts[:format] == 'data'
          if opts[:id] && opts[:id][0..0] == '0'
            link_to title, zen_path(node, link_opts), :popup=>true
          else
            link_to title, zen_path(node, link_opts)
          end
        end

        # TODO: test
        def make_wiki_link(opts)
          l = opts[:node] ? opts[:node].version.lang : visitor.lang
          if opts[:url]
            if opts[:url][0..3] == 'http'
              "<a href='#{opts[:url]}' class='wiki'>#{opts[:title]}</a>"
            else
              "<a href='http://#{l}.wikipedia.org/wiki/#{opts[:url]}' class='wiki'>#{opts[:title]}</a>"
            end
          else
            "<a href='http://#{l}.wikipedia.org/wiki/Special:Search?search=#{CGI::escape(opts[:title])}' class='wiki'>#{opts[:title]}</a>"
          end
        end

        # Create an img tag for the given image. See ApplicationHelper#zazen for details.
        def make_image(opts)
          id, style, link, mode, title = opts[:id], opts[:style], opts[:link], opts[:mode], opts[:title]
          mode ||= 'std' # default mode
          img = opts[:node] || secure(Document) { Document.find_by_zip(id) }

          return "<span class='unknownLink'>#{_('unknown document')}</span>" unless img

          if !opts[:images].nil? && !opts[:images]
            return "[#{_('image')}: #{img.version.title}]"
          end
          title = img.v_summary if title == ""

          image = img_tag(img, :mode=>mode)

          unless link
            if id[0..0] == "0" || !img.kind_of?(Image)
              # if the id starts with '0' or it is not an Image, link to data
              link = zen_path(img, :format => img.c_ext)
              link_tag = "<a class='popup' href='#{link}' target='_blank'>"
            end
          end

          style ||= ''
          case style.sub('.', '')
          when ">"
            prefix = "<div class='img_right'>"
            suffix = "</div>"
          when "<"
            prefix = "<div class='img_left'>"
            suffix = "</div>"
          when "="
            prefix = "<div class='img_center'>"
            suffix = "</div>"
          else
            prefix = suffix = ""
          end

          if title
            prefix = "#{prefix}<div class='img_with_title'>"
            suffix = "<div class='img_title'>#{ZazenParser.new(title,:helper=>self).render(:images=>false)}</div></div>#{suffix}"
          end

          if link.nil? || image[0..3] == '[:::' # do not link on placeholders
            prefix + image + suffix
          elsif link =~ /^\d+/
            prefix + make_link(:id=>link,:title=>image) + suffix
          else
            link = "http://#{link}" unless link =~ %r{(^/|.+://.+)}
            link_tag ||= "<a href='#{link}'>"
            prefix + link_tag + image + "</a>" + suffix
          end
        end

        # Create a gallery from a list of images. See ApplicationHelper#zazen for details.
        def make_gallery(ids=[], opts={})
          if ids == []
            images = secure(Image) { Image.find(:all, :conditions => ["parent_id = ?", (opts[:node] || @node)[:id]], :order => "position ASC, name ASC")}
          else
            ids = ids.map{|i| i.to_i}
            images = ids == [] ? nil : secure(Document) { Document.find(:all, :conditions=>"zip IN (#{ids.join(',')})") }
            # order like ids :
            images.sort! {|a,b| ids.index(a[:zip].to_i) <=> ids.index(b[:zip].to_i) } if images
          end

          render_to_string( :partial=>'nodes/gallery', :locals=>{:gallery=>images} )
        end

        def list_nodes(ids=[], opts={})
          style = opts[:style] || ''
          node  = opts[:node] || @node
          case style.sub('.', '')
          when ">"
            prefix = "<div class='img_right'>"
            suffix = "</div>"
          when "<"
            prefix = "<div class='img_left'>"
            suffix = "</div>"
          when "="
            prefix = "<div class='img_center'>"
            suffix = "</div>"
          else
            prefix = suffix = ""
          end
          if ids == []
            docs = node.find(:all, 'documents')
          elsif ids[0] == "d"
            docs = node.find(:all, 'documents where kpath not like "NDI%"')
          elsif ids[0] == "i"
            docs = node.find(:all, 'images')
          else
            ids = ids.map{|i| i.to_i}
            docs = ids == [] ? nil : secure!(Document) { Document.find(:all, :order=>'name ASC', :conditions=>"zip IN (#{ids.join(',')})") }
            # order like ids :
            docs.sort! {|a,b| ids.index(a[:zip].to_i) <=> ids.index(b[:zip].to_i) } if docs
          end
          return '' unless docs
          prefix + render_to_string( :partial=>'nodes/list_nodes', :locals=>{:docs=>docs}) + suffix
        rescue
          '[no document found]'
        end

      end
    end # ViewMethods
  end # Use
end # Zena