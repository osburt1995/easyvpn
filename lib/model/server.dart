class Server {
  //int id;
  String name;
  String icon;
  String address;
  String username;
  String password;

  Server({
    //this.id,
    this.name,
    this.icon,
    this.address,
    this.username,
    this.password,
  });

  Server.fromJson(Map<String, dynamic> json) {
    //id = json['id'];
    name = json['name'];
    icon = json['icon'];
    address = json['address'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.name;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['address'] = this.address;
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}
