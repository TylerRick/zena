# gettext custom strings (dynamically constructed. please add a comment for the context where the string is used)
require 'gettext'
module Zena
  def CustomGettext
    N_('help_tab')  # edit form tab name
    
    N_('drive_tab') # drive form tab name
    N_('links_tab') # drive form tab name
    
    N_('text_tab')  # edit form tab name
    N_('title_tab') # edit form tab name
    N_('import_tab') # edit form tab name
    N_('textdocument_tab')  # edit form tab
    N_('image_tab')         # edit form tab
    N_('document_tab')      # edit form tab
    N_('contact_tab')       # edit form tab
    
    N_('file_tab')              # document form tab name
    N_('template_tab')          # document form tab name
    N_('text_doc_tab')          # document form tab name
    N_('custom_tab')            # custom form tab name
    
    N_('btn_add_doc') # used by zafu layout template
    N_('btn_add') # used by zafu layout template
    N_('btn_add_comment') # used by zafu layout template
    N_('btn_title_edit')
    N_('btn_title_drive')
    
    # admin icons
    N_('relation_img')
    N_('relations_img')
    N_('site_img')
    N_('btn_site_add')
    N_('options')
    N_('public group')
    N_('site group')
    N_('btn_relation_add')
    N_('virtual_class_img')
    N_('btn_virtual_class_add')
    
    N_('posted by')
    N_('original by')
    N_('modified by')
    
    N_('img_public')         # icon
    N_('img_private')        # icon
    N_('img_custom_inherit') # icon
    N_('img_user')          # edit users (admin)
    N_('img_user_admin')    # edit users (admin)
    N_('img_user_su')       # edit users (admin)
    N_('img_user_pub')      # edit users (admin)
    N_('img_group')         # edit groups (admin)
    N_('img_group_pub')     # edit users (admin)
    N_('img_group_site')    # edit users (admin)
    N_('img_comments')          # comments
    N_('img_comments_inside')   # comments
    N_('inside')                # comments
    N_('outside')               # comments
    N_('open')                  # comments
    N_('closed')                # comments
    
    N_('img_prev_page')     # admin lists
    N_('img_next_page')     # admin lists
    
    N_('admin')             # user status
    N_('user')              # user status
    N_('commentator')       # user status
    N_('moderated')         # user status
    N_('reader')            # user status
    N_('deleted')           # user status
    
    N_('%{ext} document')   # alt attribute for img_tag 
    N_('%{type} node')      # alt attribute for img_tag
    
    N_('no result found')   # search template
    N_('search results')    # search template
    
    N_('btn_unpublish')    # version action
    N_('btn_destroy')
    N_('btn_propose')
    N_('btn_refuse')
    N_('btn_destroy_version')
    N_('btn_redit')
    
    N_('status_50')         # published
    N_('status_40')         # proposed
    N_('status_35')         # proposed with
    N_('status_33')         # redaction visible
    N_('status_30')         # redaction
    N_('status_20')         # replaced
    N_('status_10')         # removed
    N_('status_0')          # deleted
    
    N_('en')
    N_('fr')
    N_('de')
    N_('Monday')
    N_('Tuesday')
    N_('Wednesday')
    N_('Thursday')
    N_('Friday')
    N_('Saturday')
    N_('Sunday')
    
    N_('news_date')         # calendar day (event list view)
    
    N_('Mon')
    N_('Tue')
    N_('Wed')
    N_('Thu')
    N_('Fri')
    N_('Sat')
    N_('Sun')
    
    N_('January')
    N_('February')
    N_('March')
    N_('April')
    N_('May')
    N_('June')
    N_('July')
    N_('August')
    N_('September')
    N_('October')
    N_('November')
    N_('December')
    
    N_('Jan')
    N_('Feb')
    N_('Mar')
    N_('Apr')
    N_('May')
    N_('Jun')
    N_('Jul')
    N_('Aug')
    N_('Sep')
    N_('Oct')
    N_('Nov')
    N_('Dec')
    
    N_('User name:')  # login form
    N_('Password:')   # login form
    
    # temporary (seems like the updatepo script does not parse 'templates' directory)
    N_('you are editing the original')
    N_('redaction saved')
    
    # failed to find
    N_('rebuild') # application
    # contact
    N_('first_name')
    N_('name')
    N_('address')
    N_('zip')
    N_('city')
    N_('country')
    N_('telephone')
    N_('mobile')
    N_('email')
    N_('birthday')
  end
end