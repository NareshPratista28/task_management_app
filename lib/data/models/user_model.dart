class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignIn;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
    this.createdAt,
    this.lastSignIn,
  });

  factory UserModel.fromFirebaseUser(user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      lastSignIn: user.metadata.lastSignInTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'lastSignIn': lastSignIn?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      emailVerified: json['emailVerified'] ?? false,
      createdAt:
          json['createdAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
              : null,
      lastSignIn:
          json['lastSignIn'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['lastSignIn'])
              : null,
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? lastSignIn,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastSignIn: lastSignIn ?? this.lastSignIn,
    );
  }
}
