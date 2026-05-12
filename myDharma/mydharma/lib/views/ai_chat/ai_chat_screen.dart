import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/textured_background.dart';
import '../../models/chat_message.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  static const routeName = '/ai-chat';

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _scrollController = ScrollController();
  final _messageController = TextEditingController();
  final _messages = <ChatMessage>[
    const ChatMessage(
      text:
          'I have a major business meeting today that could change everything. I want to stay confident and calm.',
      isUser: true,
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TexturedBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: const _KarishyeAppBar(),
        body: Column(
          children: [
            const _TopicHeader(),
            Expanded(
              child: ListView(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 24.h),
                children: [
                  for (final entry in _messages.indexed)
                    _FadeInMessage(
                      delay: Duration(milliseconds: 90 * entry.$1),
                      child: _ChatBubble(message: entry.$2),
                    ),
                  SizedBox(height: 28.h),
                  const _AssistantHeader(),
                  SizedBox(height: 10.h),
                  _AssistantResponse(
                    text: _messages.first.text,
                    onAdd: _addToActivity,
                  ),
                ],
              ),
            ),
            _ChatInput(controller: _messageController, onSend: _sendMessage),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _messages.add(
        const ChatMessage(
          text:
              'Karishye has noted your intent. Begin with one calm breath and a clear sankalpa.',
          isUser: false,
        ),
      );
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _addToActivity() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Added to My Activity.')));
  }
}

class _KarishyeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _KarishyeAppBar();

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 56.h,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      titleSpacing: 18.w,
      title: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.accent, width: 1.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Image.asset(
              'assets/chatscreen/chatIcon.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'Ask Karishye',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primaryText,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            customBorder: const CircleBorder(),
            child: Icon(Icons.close, color: AppColors.primaryText, size: 22.sp),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Container(height: 1.h, color: AppColors.accent),
      ),
    );
  }
}

class _TopicHeader extends StatelessWidget {
  const _TopicHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .62),
        border: Border(
          bottom: BorderSide(color: AppColors.line.withValues(alpha: .7)),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            customBorder: const CircleBorder(),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primaryText,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Stay confident in Business Meeting',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryText,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 26.w,
            height: 26.w,
            decoration: const BoxDecoration(
              color: AppColors.primaryText,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, color: Colors.white, size: 18.sp),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 318.w,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black87,
            fontSize: 14.sp,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _AssistantHeader extends StatelessWidget {
  const _AssistantHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/chatscreen/feather.png', width: 24.w, height: 24.w),
        SizedBox(width: 8.w),
        Text(
          'Karishye',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(height: 1.5.h, color: AppColors.accent),
        ),
      ],
    );
  }
}

class _AssistantResponse extends StatelessWidget {
  const _AssistantResponse({required this.text, required this.onAdd});

  final String text;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ParchmentMessage(text: text),
        SizedBox(height: 24.h),
        const _RitualRecommendationCard(),
        SizedBox(height: 58.h),
        OutlinedButton(
          onPressed: onAdd,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(190.w, 54.h),
            side: const BorderSide(color: AppColors.primaryText),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1.r),
            ),
            backgroundColor: Colors.white.withValues(alpha: .24),
          ),
          child: Text(
            'Add to My Activity',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black87,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _ParchmentMessage extends StatelessWidget {
  const _ParchmentMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3DCA2),
        border: Border.all(color: AppColors.accent),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: .18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black87,
          fontSize: 14.sp,
          height: 1.42,
        ),
      ),
    );
  }
}

class _RitualRecommendationCard extends StatelessWidget {
  const _RitualRecommendationCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.w,
      height: 366.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 20.w,
            right: -12.w,
            top: -13.h,
            bottom: 12.h,
            child: Transform.rotate(
              angle: .045,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE88D31)),
                ),
              ),
            ),
          ),
          Container(
            width: 286.w,
            height: 350.h,
            padding: EdgeInsets.fromLTRB(24.w, 34.h, 24.w, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE88D31), width: 1.4),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/chatscreen/diya.png',
                  width: 176.w,
                  height: 142.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 17.w,
                      height: 17.w,
                      margin: EdgeInsets.only(top: 3.h),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryText,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Light a Ghee Diya Facing East\n(Before Leaving)',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.black87,
                                  fontSize: 14.sp,
                                  height: 1.35,
                                ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Invoke inner light and clarity by\nlighting a diya with a small prayer.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.black54,
                                  fontSize: 14.sp,
                                  height: 1.45,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/chatscreen/dotIndicatorIcon.png',
                        width: 18.w,
                      ),
                      SizedBox(width: 5.w),
                      _Dot(active: true),
                      SizedBox(width: 5.w),
                      const _Dot(active: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE88D31), width: 1.4),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 12.w, 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .18),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Share your wish, worry or intent...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontSize: 13.sp,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: onSend,
              child: AnimatedScale(
                scale: 1,
                duration: const Duration(milliseconds: 120),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFA32974),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(9.w),
                    child: Image.asset('assets/chatscreen/sendIcon.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FadeInMessage extends StatelessWidget {
  const _FadeInMessage({required this.child, required this.delay});

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 360 + delay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
