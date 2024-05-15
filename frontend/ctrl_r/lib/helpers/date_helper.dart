

class DateHelper {
static String formatTimestamp(String timestampString) {
  DateTime timestamp = DateTime.parse(timestampString);
  String formattedDate = '${timestamp.day}/${timestamp.month}/${timestamp.year}'; 

  String formattedTime = '${timestamp.hour}:${timestamp.minute}'; 

  return '$formattedDate $formattedTime'; 
}


}