(function() { this.JST || (this.JST = {}); this.JST["textlab/templates/xml-editor"] = function(obj){var __p=[],print=function(){__p.push.apply(__p,arguments);};with(obj||{}){__p.push('\n<div class=\'btn-toolbar xml-editor-toolbar\'>\n  \n  ');  if( showTags ) { ; __p.push(' \n    <div class="dropdown">\n      <button id="xml-tag-dropdown" class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">\n        Tags\n        <span class="caret"></span>\n      </button>\n      <ul class="dropdown-menu scrollable-menu">\n        ');  _.each( tags, function(tag) { ; __p.push('\n          ');  if( tag == 'pb' ) { ; __p.push(' \n            <li><a class=\'pb-button\' data-tag-id=\'',  tag ,'\' href="#">',  tag ,'</a></li>\n          ');  } else { ; __p.push(' \n            <li><a class=\'tag-menu-item\' data-tag-id=\'',  tag ,'\' href="#">',  tag ,'</a></li>          \n          ');  } ; __p.push('\n        ');  }) ; __p.push('\n      </ul>\n    </div>\n  \n    <button class=\'tag-menu-item toolbar-button btn btn-sm btn-default\' data-tag-id=\'milestone\' href=\'#\' >milestone</button>\n    <button class=\'pb-button toolbar-button btn btn-sm btn-default\' data-tag-id=\'pb\' href=\'#\'>pb</button>\n    <button class=\'tag-menu-item toolbar-button btn btn-sm btn-default\' data-tag-id=\'ab\' href=\'#\' >ab</button>\n    <button class=\'lb-mode-button btn btn-sm btn-default\' data-tag-id=\'lb\' href=\'#\' >lb</button>\n                \n  ');  } ; __p.push('\n\n  <div class="status-message">',  statusMessage ,'</div>  \n  <div class="error-message"></div>\n\n  <div class=\'actions ',  actionWidthClass ,'\' >    \n    <button class=\'toolbar-button btn btn-sm btn-default preview-button\' href=\'#\' ><i class="fa fa-cloud-upload" aria-hidden="true"></i> Preview</button>    \n    ');  if( showPublishButton ) { ; __p.push(' \n      <button class=\'toolbar-button btn btn-sm btn-default publish-button ',  published ? 'hidden' : '' ,'\' href=\'#\' ><i class="fa fa-star" aria-hidden="true"></i> Accept</button>\n      <button class=\'toolbar-button btn btn-sm btn-default unpublish-button ',  published ? '' : 'hidden' ,'\' href=\'#\' ><i class="fa fa-star-o" aria-hidden="true"></i> Return</button>          \n    ');  }; __p.push('\n\n    ');  if( showReturnButton ) { ; __p.push('\n      <button class=\'toolbar-button btn btn-sm btn-default return-button ',  submitted ? '' : 'hidden' ,'\' href=\'#\' ><i class="fa fa-send-o" aria-hidden="true"></i> Return to Sender</button>         \n    ');  } ; __p.push('\n\n    ');  if( showActionMenu ) { ; __p.push(' \n      <div class="dropdown">\n        <button id="action-dropdown" class="btn btn-sm btn-default dropdown-toggle" type="button" data-toggle="dropdown">\n          <i class="fa fa-bars" aria-hidden="true"></i>\n        </button>\n        <ul class="dropdown-menu">\n          ');  if( showSubmitButton ) { ; __p.push('\n            <li><a class=\'submit-button ',  submitted ? 'hidden' : '' ,'\' href="#"><i class="fa fa-send" aria-hidden="true"></i> Submit</a></li>\n          ');  } ; __p.push('\n          <li><a class=\'share-button ',  shared ? 'hidden' : '' ,'\' href="#"><i class="fa fa-share-square" aria-hidden="true"></i> Share</a></li>\n          <li><a class=\'stop-sharing-button ',  shared ? '' : 'hidden' ,'\' href="#"><i class="fa fa-share-square-o" aria-hidden="true"></i> Stop Sharing</a></li>\n          <li><a class=\'rename-button\' href="#"><i class="fa fa-pencil-square" aria-hidden="true"></i> Rename</a></li>\n          <li><a class=\'delete-button\' href="#"><i class="fa fa-trash" aria-hidden="true"></i> Delete</a></li>\n        </ul>\n      </div>\n    ');  } ; __p.push('\n    \n  </div>\n  \n</div>\n\n<div id=\'editor-viewport\'>\n  <textarea id=\'codemirror\'></textarea>\n</div>\n');}return __p.join('');};
}).call(this);