$(document).ready(function(){


//scroll when you click arrows-----------------------------------
    var $item = $('div.container'), 
        visible = 5, 
        index = 0, 
        endIndex = ( $item.length / visible ) - 1; 
    
    $('div#forward').click(function(){
        if(index < endIndex ){
          index++;
          $item.animate({'left':'-=1270px'});
        }
    });
    
    $('div#back').click(function(){
        if(index > 0){
          index--;            
          $item.animate({'left':'+=1270px'});
        }
    });


  $("a.add_fields").data("association-insertion-method", 'prepend').data("association-insertion-node", '.spaceform');



});