/*
 * AJAX file to add and update items in the shopping cart
 * Based on Ajax for Java Developers: Build dynamic Java applications - Philip McCarthy
 */
/* global JsonConvert */

// Timestamp of cart that page was last updated with
var lastCartUpdate = 0;

/*
 * Add the specified item to the shopping cart, via Ajax call
 * itemCode - product code of the item to add
 */
function addToCart(itemCode) {
 /**
  * Create the variable req for the object newXMLHttpRequest
  */
 var req = getSomeJSON();
 /**
  * Check the ready state based on the function getReadyStateHandler defined in ajax1.js
  * Create the request to newXMLHttpRequest object
  * Parameters: POST Method, Data file cart.do, Asynchronous communication
  */
 req.onreadystatechange = getReadyStateHandler(req, updateCart);
 req.open("POST", "cart.do", true); 
 req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
 req.send("action=add&item="+itemCode); //Execute doPost method from CartServlet.java
}
/*
 * Remove the specified item from the shopping cart, via Ajax call
 * itemCode - product code of the item to add
 */
function removeToCart(itemCode) {
 /**
  * Create the variable req for the object newXMLHttpRequest
  */
 var req = getSomeJSON();
 /**
  * Check the ready state based on the function getReadyStateHandler defined in ajax1.js
  * Create the request to newXMLHttpRequest object
  * Parameters: POST Method, Data file cart.do, Asynchronous communication
  */
 req.onreadystatechange = getReadyStateHandler(req, updateCart);
 req.open("POST", "cart.do", true); 
 req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
 req.send("action=remove&item="+itemCode); //Execute doPost method from CartServlet.java
}
/**
 * Function updateCart used to update the cart in the same page
 * List the items that are added to the Cart
 * Show the total cost of the products
 * Variable cartXML is the XML string that is built by CartServlet using the
 * method toXML of Cart.java
 */
function updateCart(cartJSON) {
    console.log(cartJSON); //Testing purposes
    var myJson = JSON.parse(cartJSON);
    var i,x =""; //Variables to construct the cart
    //HTML DOM method to return the element that has the ID attribute with the specified value "total"
    document.getElementById("total").innerHTML = myJson["cart"]["@total"];   
    //Get the "generated" parameter from JSON string
    var generated = myJson["cart"]["@generated"];
    if (generated > lastCartUpdate){
        lastCartUpdate = generated;
        for (i=0; i< myJson["cart"]["item"].length; i++){
            x +=myJson["cart"]["item"][i]["name"] + ": " + myJson["cart"]["item"][i]["quantity"] + "<br>";
        }
        //HTML DOM method to return the element that has the ID attribute with the specified value "contents"
        document.getElementById("contents").innerHTML = x;
    }
    }

