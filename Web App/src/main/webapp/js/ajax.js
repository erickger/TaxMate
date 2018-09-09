/**
 * JSON and AJAX script
 * Customization of XMLHttpRequest to support Old Versions of Internet Explorer
 * @returns {XMLHttpRequest}
 */
function getSomeJSON() {

    var xhr;
    if(window.XMLHttpRequest)
           //code for modern browsers
           xhr = new XMLHttpRequest();
    else
           //code for old IE browsers
           xhr = ActiveXObject("Microsoft.XMLHTTP");     
    return xhr;
    }

 function getReadyStateHandler(req, responseJSONHandler) {

   // Return an anonymous function that listens to the XMLHttpRequest instance
   return function () {

     // If the request's status is "complete" (Code 4)
     if (req.readyState === 4) {
       
       // Check that we received a successful response from the server (Code 200)
       if (req.status === 200) {

         // Pass the JSON payload of the response to the handler function.
         // Get the response data as String
         responseJSONHandler(req.responseText);

       } else {

         // An HTTP problem has occurred
         alert("HTTP error "+req.status+": "+req.statusText);
       }
     }
   }
 }



