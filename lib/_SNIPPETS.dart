///for loop:
/*
for( var i = 0 ; i < 10; i++ ) {
  //code...
}
*/

///iterate map:
/*
documentData.forEach((k, v) {
  //do something with k and v;
});
*/

///iterate list:
/*
for(final e in li){
  var currentElement = e;
}
*/

///map to list:
/*
List documentList = documentMap.entries.map((entry) => entry.value).toList();
*/


///loading indicator with timer:
/*


child: loadingTimerFinished
  ? Text(
      buttonText,
      textAlign: TextAlign.center,
      softWrap: true,
      style: TextStyle(fontSize: 40, color: textColor, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    )
  : CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
    ),
*/


///wait for 5 seconds:
//await Future.delayed(Duration(seconds: 1));

