(function() { this.JST || (this.JST = {}); this.JST["tl-viewer/templates/step-sequence-panel"] = function(obj){var __p=[],print=function(){__p.push.apply(__p,arguments);};with(obj||{}){__p.push('<h4><a href="#" class=\'back-to-list-link\'>Sequences for Leaf</a> / ',  name ,' by username (Step ',  stepNumber + 1 ,' of ',  maxSteps ,') </h4>\n\n<table id="sequence-grid" class="table">\n  <tr>\n    <th>Step</th>\n    <th>Narrative</th>\n  </tr>\n  <tr>\n    <td class=\'step-column\'>',  step.step ,'</td>\n    <td class=\'narrative-column\'>',  step.narrative ,'</td>\n  </tr>\n</table>\n<div class=\'actions\'>\n    <button class=\'btn btn-default toggle-grid-button\' href=\'#\' >Show All Steps</button>\n    <button class=\'btn btn-default prev-step-button\' href=\'#\' ><i class="fa fa-caret-left" aria-hidden="true"></i>  Previous Step</button>\n    ');  for( var i=0; i < maxSteps; i++ ) { ; __p.push(' \n      <button data-step-number=\'',  i ,'\' class=\'btn btn-default goto-step-button ',  (i==stepNumber) ? "active" : "" ,'\' href=\'#\' >',  i + 1 ,'</button>\n    ');  } ; __p.push('\n    <button class=\'btn btn-primary next-step-button\' href=\'#\' >Next Step <i class="fa fa-caret-right" aria-hidden="true"></i></button>\n</div>\n');}return __p.join('');};
}).call(this);