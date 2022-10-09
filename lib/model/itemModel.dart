class Item {
  final int id;
  final String m_id;
  final String i_name;
  final String i_picture;
  final String i_desc;
  final String i_price;
  final String i_status;
  final String created_at;
  final String updated_at;

  Item(
      this.id,
      this.m_id,
      this.i_name,
      this.i_picture,
      this.i_desc,
      this.i_price,
      this.i_status,
      this.created_at,
      this.updated_at
      );

  Item.fromJson(Map<String, dynamic> json)
      :
        id = json['id'],
        m_id = json['m_id'],
        i_name = json['i_name'],
        i_picture = json['i_picture'],
        i_desc = json['i_desc'],
        i_price = json['i_price'],
        i_status = json['i_status'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];


  Map<String, dynamic> toJson() => {
    'id': id,
    'm_name': m_id,
    'i_name': i_name,
    'i_picture': i_picture,
    'i_desc': i_desc,
    'i_price': i_price,
    'i_status': i_status,
    'created_at': created_at,
    'updated_at': updated_at
  };

  int get getMId {
    return id;
  }

  String get getMName {
    return m_id;
  }

  String get getMPicture {
    return i_name;
  }

  String get getMLatitude {
    return i_picture;
  }

  String get getMLongitude {
    return i_desc;
  }

  String get getMDesc {
    return i_price;
  }

  String get getIStatus {
    return i_status;
  }


  String get getCreatedAt {
    return created_at;
  }

  String get getUpdatedAt {
    return updated_at;
  }
}
