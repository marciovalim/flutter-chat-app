import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/di/getIt.dart';
import 'package:flutter_chat_app/core/entities/chat_route_params.dart';
import 'package:flutter_chat_app/core/models/message_model.dart';
import 'package:flutter_chat_app/core/services/auth_service.dart';
import 'package:flutter_chat_app/core/services/database_queries.dart';
import 'package:flutter_chat_app/plugins/realtime_pagination/realtime_pagination.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queries = getIt<DatabaseQueries>();
    final chatParams = Provider.of<ChatRouteParams>(context, listen: false);
    final currentUserEmail = AuthService.currentUser.email;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: RealtimePagination(
        itemsPerPage: 20,
        reverse: true,
        query: queries.allMessagesIn(chatParams.chatDoc),
        emptyDisplay: Container(),
        initialLoading: Container(),
        itemBuilder: (index, context, docSnapshot) {
          final message = MessageModel.fromMap(docSnapshot.data());
          return Message(
            content: message.content,
            sendByCurrentUser: message.senderEmail == currentUserEmail,
          );
        },
      ),
    );
  }
}

class Message extends StatelessWidget {
  final bool sendByCurrentUser;
  final String content;

  const Message({
    Key key,
    @required this.sendByCurrentUser,
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: sendByCurrentUser ? 5 : 20,
      ),
      child: Align(
        alignment:
            sendByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
            color: sendByCurrentUser ? Colors.green[500] : Colors.green[700],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            content,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
