import com.temboo.core.*;
import com.temboo.Library.Google.Calendar.*;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("", "", "");


String refreshEvents() {
  // Create the Choreo object using your Temboo session
  SearchEvents searchEventsChoreo = new SearchEvents(session);

  // Set credential
  searchEventsChoreo.setCredential("SmartTable");

  // Set inputs
  searchEventsChoreo.setOrderBy("startTime");
  searchEventsChoreo.setSingleEvent("1");
  searchEventsChoreo.setCalendarID("");

  // Run the Choreo and store the results
  SearchEventsResultSet searchEventsResults = searchEventsChoreo.run();

  String eventsJson = searchEventsResults.getResponse();
  return eventsJson;

}