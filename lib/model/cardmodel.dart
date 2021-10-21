
class Note {

  int _id;
  String _title;
  String _description;
  String _price;
  String _quantity;
  String _image;

  Note(this._title, this._price, this._quantity,this._image, [this._description]);

  Note.withId(this._id, this._title, this._price, this._quantity,this._image, [this._description]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  String get price => _price;

  String get quantity => _quantity;
  String get image => _image;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set image(String imagelink) {

      this._image = imagelink;

  }

  set price(String price) {
    this._price = price;
  }

  set quantity(String qun) {
    this._quantity = qun;
  }


  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['image'] = _image;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._price = map['price'];
    this._quantity = map['quantity'];
    this._image = map['image'];
  }
}









