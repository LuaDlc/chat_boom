// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatUser {
  //classe responsavel para retornar quando fizer login ou signup
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });
}
