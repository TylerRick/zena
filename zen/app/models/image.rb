=begin rdoc
An Image is a Document with a file that we can view inline. An image can be displayed in various formats (defined through modes). These modes are defined for each Site through Iformat. Default modes:

  'tiny' => { :size=>:force, :width=>16,  :height=>16,                },
  'mini' => { :size=>:force, :width=>32,  :ratio=>1.0,                },
  'pv'   => { :size=>:force, :width=>70,  :ratio=>1.0                 },
  'med'  => { :size=>:limit, :width=>280, :ratio=>2/3.0               },
  'top'  => { :size=>:force, :width=>280, :ratio=>2.0/3.0, :gravity=>Magick::NorthGravity},
  'mid'  => { :size=>:force, :width=>280, :ratio=>2.0/3.0, :gravity=>Magick::CenterGravity},
  'low'  => { :size=>:force, :width=>280, :ratio=>2.0/3.0, :gravity=>Magick::SouthGravity},
  'edit' => { :size=>:limit, :width=>400, :height=>400                },
  'std'  => { :size=>:limit, :width=>600, :ratio=>2/3.0               },
  'full' => { :size=>:keep },
  
To display an image with one of those formats, you use the 'img_tag' helper :

  img_tag(@node, :mode=>'med')
  
For more information on img_tag, have a look at ApplicationHelper#img_tag.

An image can be croped by changing the 'crop' pseudo attribute (see Image#crop= ) :

  @node.update_attributes(:c_crop=>{:x=>10, :y=>10, :width=>30, :height=>60})

=== Version

The version class used by images is the ImageVersion.

=== Content

Content (file data) is managed by the ImageContent. This class is responsible for storing the file and retrieving the data. It provides the following attributes to the Image :

c_size(format)::    file size for the image at the given format
c_ext::             file extension
c_content_type::    file content_type   
c_width(format)::   image width in pixel for the given format
c_height(format)::  image height in pixel for the given format

=== links

Default links for Image are:

icon_for::  become the unique 'icon' for the linked node.

Example on how to use 'icon' with ruby:
 @node.icon.img_tag('pv')   <= display the node's icon with the 'pv' (preview) format.

Same example in a zafu template:
 <r:img src='icon' format='pv'/>

or to create a link to the article using the icon:
 <r:img src='icon' format='pv' href='self'/>
 
=end
class Image < Document
  class << self
    def accept_content_type?(content_type)
      ImageBuilder.image_content_type?(content_type)
    end
    
    # This is a callback from acts_as_multiversioned
    def version_class
      ImageVersion
    end
    
    # Class list to which this class can change to
    def change_to_classes_for_form
      classes_for_form(:class => 'Image')
    end
  end
  # Crop the image using the 'crop' hash with the top left corner position (:x, :y) and the width and height (:width, :heigt). Example:
  #   @node.crop = {:x=>10, :y=>10, :width=>30, :height=>60}
  # Be carefull as this method changes the current file. So you should make a backup version before croping the image (the popup editor displays a warning).
  def c_crop=(format)
    x, y, w, h = [format[:x].to_f, 0].max, [format[:y].to_f,0].max, [format[:w].to_f, c_width].min, [format[:h].to_f, c_height].min
    if format[:max_value] || format[:format] || (x < c_width && y < c_height && w > 0 && h > 0) && !(x==0 && y==0 && w == c_width && h == c_height)
      # do crop
      if file = version.content.crop(format)
        # crop can return nil, check first.
        self.c_file = file
      end
    else
      # nothing to do: ignore this operation.
    end
  end
  
  # filter attributes so there is no 'crop' with a new file
  def filter_attributes(attributes)
    attrs = super
    attrs.delete('c_crop') if attributes['c_file'] && attributes['c_crop']
    attrs
  end
  
  # Return the image file for the given format (see Image for information on format)
  def file(format=nil)
    version.file(format)
  end
  
  # Return the size of the image for the given format (see Image for information on format)
  def filesize(format=nil)
    version.filesize(format)
  end
end
