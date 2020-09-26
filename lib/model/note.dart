class Note
{
  String _title;
  String _details;


  String get details => _details;

  set details(String value) {
    _details = value;
  }

  Note(this._title, this._details);

  String get title => _title;

  set title(String value) {
    _title = value;
  }


}