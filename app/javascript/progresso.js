$(document).on("turbolinks:load", function(){
 $("#upload_file").on("direct-uploads:start", function(){
    $("h4.progress").show();
 });

 $("#post_files").on("direct-upload:progress", function(event){
    $("h4.progress span.progress_count").html(event.detail.progress);
 });
});
