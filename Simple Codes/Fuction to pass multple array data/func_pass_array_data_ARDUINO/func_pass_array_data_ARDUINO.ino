// https://www.hex705.com/arduino-to-processing-multiple-data-point/

void sendSensors(){

   // built and send package
   Serial.print(START_BYTE, BYTE);     // send START_BYTE as a BYTE

   for (int i = 0; i < MAX_NUMBER_SENSORS; i ++) {
       Serial.print(sensors[i], DEC);     // send the sensorValues out via USB as a DECimal
       Serial.print(DELIMITER, BYTE);     // commas separate data
   }  // end for

   Serial.print(END_BYTE, BYTE);                // end of message

}  // end sendSensors


/* PROCESSING CODE

void serialEvent( Serial usbPort ){
  
      madeUSBcontact = true ;   
  
      String usbString = usbPort.readStringUntil( END_BYTE );  
   
      if ( usbString != null ){
          
           usbString = trim( usbString );      

        
           int incomingSensorStream[] = int (splitTokens( usbString,  TOKENS )); 
           
           // this is a hack to get the data from incomingSensorStream (local) 
           // into sensorData  (global)
           
           sensorData = new int[incomingSensorStream.length];
           arrayCopy( incomingSensorStream  , sensorData ); 
                  
        }  // end if
     
      usbPort.clear();        // dumps buffer before asking for next data point
      usbPort.write( '\r' );  // send a carriage return to continue communication 
          
} // end serialEvent 

*/