import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/chat_repository.dart';
import 'package:gemini_chat_bloc/features/auth/repositories/storage_repository.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _messageController;
  late final ChatRepository chatRepo;

  final apiKey = dotenv.env['API_KEY'] ?? '';

  @override
  void initState() {
    _messageController = TextEditingController();
    chatRepo = ChatRepository(storageRepository: FirebaseStorageRepository());
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: const [
            // Consumer(
            //   builder: (context, ref, child) {
            //     return IconButton(
            //       onPressed: () {
            //         ref.read(authProvider).singout();
            //       },
            //       icon: const Icon(
            //         Icons.logout,
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child:
              // StreamBuilder<Message>(
              //     stream: chatRepo.messagesListController.stream,
              //     builder: (context, snapshot) {
              // return
              Column(
            children: [
              // Message List
              // StreamBuilder<Message>(
              //     stream: ChatRepository(
              //             storageRepository: FirebaseStorageRepository())
              //         .messagesListController
              //         .stream,
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         return
              Expanded(child: Text(
                      // snapshot.data?.message ??
                      'hey')
                  //  MessagesList(
                  //   userId: FirebaseAuth.instance.currentUser!.uid,
                  // ),
                  ),

              //       return const Expanded(
              //         child: Text('empty list'),
              //       );
              //     }),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    // Message Text field
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ask any question',
                        ),
                      ),
                    ),

                    // Image Button
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (_) => const SendImageScreen(),
                    //       ),
                    //     );
                    //   },
                    //   icon: const Icon(
                    //     Icons.image,
                    //   ),
                    // ),

                    // Send Button
                    IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> sendMessage() async {
    // final message = _messageController.text.trim();
    // if (message.isEmpty) return;

    // await chatRepo.sendTextMessage(
    //   textPrompt: _messageController.text,
    //   apiKey: apiKey,
    // );

    // await ref.read(chatProvider).sendTextMessage(
    //       apiKey: apiKey,
    //       textPrompt: _messageController.text,
    //     );
    // _messageController.clear();
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final prompt = 'Write a story about a magic backpack.';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    print(response.text);
  }
}
