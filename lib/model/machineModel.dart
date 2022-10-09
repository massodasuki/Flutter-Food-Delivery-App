class Machine {
  final String m_id;
  final String m_name;
  final String m_picture;
  final String m_latitude;
  final String m_longitude;
  final String m_desc;
  final String created_at;
  final String updated_at;

  Machine(
      this.m_id,
      this.m_name,
      this.m_picture,
      this.m_latitude,
      this.m_longitude,
      this.m_desc,
      this.created_at,
      this.updated_at
      );

  Machine.fromJson(Map<String, dynamic> json)
      :
        m_id = json['m_id'],
        m_name = json['m_name'],
        m_picture = json['m_picture'],
        m_latitude = json['m_latitude'],
        m_longitude = json['m_longitude'],
        m_desc = json['m_desc'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];


  Map<String, dynamic> toJson() => {
    'm_id': m_id,
    'm_name': m_name,
    'm_picture': m_picture,
    'm_latitude': m_latitude,
    'm_longitude': m_longitude,
    'm_desc': m_desc,
    'created_at': created_at,
    'updated_at': updated_at
  };

  String get getMId {
    return m_id;
  }

  String get getMName {
    return m_name;
  }

  String get getMPicture {
    return m_picture;
  }

  String get getMLatitude {
    return m_latitude;
  }

  String get getMLongitude {
    return m_longitude;
  }

  String get getMDesc {
    return m_desc;
  }

  String get getCreatedAt {
    return created_at;
  }

  String get getUpdatedAt {
    return updated_at;
  }
}
