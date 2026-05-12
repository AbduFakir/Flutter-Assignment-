import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/textured_background.dart';
import '../../models/home_life_event.dart';
import '../../models/life_event.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({this.event, this.homeEvent, super.key});

  static const routeName = '/event-details';

  final LifeEvent? event;
  final HomeLifeEvent? homeEvent;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController(text: 'India');
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _notesController = TextEditingController();

  var _selectedTag = 0;
  var _selectedJourney = 0;
  var _needsImmediateGuidance = true;
  var _isPlaying = false;

  static const _ritualTags = [
    'Garbhadanam',
    'Punsavanam',
    'Seemantham',
    'Garbhadhaanam',
    'Garbhdanam',
  ];

  static const _journeyOptions = [
    _JourneyOption(
      title: 'Planning',
      subtitle: 'Preparing for conception',
      iconAsset: 'assets/eventDetail/planningIcon.png',
    ),
    _JourneyOption(
      title: 'Expecting',
      subtitle: 'Currently Pregnant',
      iconAsset: 'assets/eventDetail/expectingIcon.png',
    ),
    _JourneyOption(
      title: 'Baby Arrived',
      subtitle: 'Post Birth Rituals',
      iconAsset: 'assets/eventDetail/babyArrivedIcon.png',
    ),
    _JourneyOption(
      title: 'Naming Soon',
      subtitle: 'Naamkaranam',
      iconAsset: 'assets/eventDetail/namingSoonIcon.png',
    ),
  ];

  @override
  void dispose() {
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeEvent = ModalRoute.of(context)?.settings.arguments;
    final homeEvent =
        widget.homeEvent ??
        (routeEvent is HomeLifeEvent ? routeEvent : null) ??
        (widget.event == null
            ? null
            : HomeLifeEvent(
                title: widget.event!.title,
                description: widget.event!.subtitle,
                iconAsset: 'assets/home/welcomeBabyIcon.png',
              )) ??
        const HomeLifeEvent(
          title: 'Welcoming a Baby',
          description:
              'Every ritual from conception to naming, guided with love.',
          iconAsset: 'assets/home/welcomeBabyIcon.png',
        );

    return TexturedBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: _DetailAppBar(title: homeEvent.title),
        bottomNavigationBar: const _DetailBottomNav(),
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 20.h),
                sliver: SliverList.list(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/eventDetail/baby.png',
                        height: 178.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      homeEvent.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'A child arriving is life Divine choosing your family. Every ritual marks this blessing with intention.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontSize: 12.sp,
                        height: 1.32,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const _ImageCarousel(),
                    SizedBox(height: 8.h),
                    _AudioPlayer(
                      isPlaying: _isPlaying,
                      onToggle: () => setState(() => _isPlaying = !_isPlaying),
                    ),
                    SizedBox(height: 14.h),
                    _SectionTitle('Rituals we guide'),
                    SizedBox(height: 10.h),
                    // Row 1: first 3 chips equally sized
                    Row(
                      children: [
                        for (
                          int i = 0;
                          i < 3 && i < _ritualTags.length;
                          i++
                        ) ...[
                          if (i > 0) SizedBox(width: 8.w),
                          Expanded(
                            child: _RitualChip(
                              label: _ritualTags[i],
                              selected: _selectedTag == i,
                              onTap: () => setState(() => _selectedTag = i),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Row 2: 2 chips centered, matching width of row 1 cells
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        SizedBox(width: 8.w),
                        for (int i = 3; i < _ritualTags.length; i++) ...[
                          if (i > 3) SizedBox(width: 8.w),
                          Expanded(
                            child: _RitualChip(
                              label: _ritualTags[i],
                              selected: _selectedTag == i,
                              onTap: () => setState(() => _selectedTag = i),
                            ),
                          ),
                        ],
                        SizedBox(width: 8.w),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    _SectionTitle('Request a Call back'),
                    SizedBox(height: 14.h),
                    Text(
                      'Where are you in this Journey?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _JourneyGrid(
                      options: _journeyOptions,
                      selectedIndex: _selectedJourney,
                      onSelected: (index) =>
                          setState(() => _selectedJourney = index),
                    ),
                    SizedBox(height: 18.h),
                    _SectionTitle('Where do you want this Pooja?'),
                    SizedBox(height: 10.h),
                    _FormField(
                      label: 'Country',
                      controller: _countryController,
                    ),
                    SizedBox(height: 10.h),
                    _FormField(
                      label: 'State/Region',
                      controller: _stateController,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            label: 'City',
                            controller: _cityController,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _FormField(
                            label: 'Pincode',
                            controller: _pincodeController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryText,
                          fontSize: 11.sp,
                          height: 1.5,
                        ),
                        children: const [
                          TextSpan(
                            text:
                                "Can't find the location you are looking for?\n",
                          ),
                          TextSpan(
                            text: 'Help us get to your current location →',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    _SectionTitle("Anything you'd like us to know?"),
                    SizedBox(height: 8.h),
                    _FormField(
                      label: '',
                      controller: _notesController,
                      maxLines: 6,
                      validator: (_) => null,
                    ),
                    SizedBox(height: 14.h),
                    CheckboxListTile(
                      value: _needsImmediateGuidance,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      activeColor: AppColors.primaryText,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        setState(
                          () => _needsImmediateGuidance = value ?? false,
                        );
                      },
                      title: Text(
                        'Immediate guidance needed',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.primaryText,
                              fontSize: 14.sp,
                            ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 46.h,
                        width: 184.w,
                        child: FilledButton(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primaryText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          child: Text(
                            'Request a Callback',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'Our team typically responds within 2 hours',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryText,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 18.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Callback request submitted.')),
    );
  }
}

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DetailAppBar({required this.title});

  final String title;

  @override
  Size get preferredSize => Size.fromHeight(72.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 72.h,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: .7,
      shadowColor: Colors.black.withValues(alpha: .22),
      titleSpacing: 8.w,
      title: Column(
        children: [
          SizedBox(
            height: 34.h,
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/applogo.png',
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'myDharma',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryText,
                    fontSize: 12.sp,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.accent,
                  size: 20.sp,
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.accent,
                  size: 20.sp,
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.account_circle_outlined,
                  color: AppColors.accent,
                  size: 21.sp,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.line.withValues(alpha: .8)),
          SizedBox(
            height: 27.h,
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryText,
                    size: 17.sp,
                  ),
                ),
                SizedBox(width: 7.w),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryText,
                    fontSize: 13.sp,
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

class _ImageCarousel extends StatelessWidget {
  const _ImageCarousel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent, width: 1.2),
      ),
      child: Image.asset(
        'assets/eventDetail/ritualImage.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

class _AudioPlayer extends StatelessWidget {
  const _AudioPlayer({required this.isPlaying, required this.onToggle});

  final bool isPlaying;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onToggle,
          customBorder: const CircleBorder(),
          child: Icon(
            isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
            size: 20.sp,
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: SizedBox(
            height: 2.h,
            child: LinearProgressIndicator(
              value: isPlaying ? .54 : .33,
              backgroundColor: AppColors.line,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryText),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Icon(
          Icons.volume_up_rounded,
          size: 16.sp,
          color: AppColors.primaryText,
        ),
      ],
    );
  }
}

class _RitualChip extends StatelessWidget {
  const _RitualChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3C4),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: AppColors.accent,
            width: selected ? 1.8 : 1.2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.primaryText,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _JourneyGrid extends StatelessWidget {
  const _JourneyGrid({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_JourneyOption> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          itemCount: options.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 520 ? 4 : 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 2.18,
          ),
          itemBuilder: (context, index) {
            return _JourneyCard(
              option: options[index],
              selected: selectedIndex == index,
              onTap: () => onSelected(index),
            );
          },
        );
      },
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _JourneyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.accent.withValues(alpha: .1)
          : Colors.white.withValues(alpha: .45),
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(9.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: selected
                  ? AppColors.accent
                  : AppColors.accent.withValues(alpha: .8),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Image.asset(option.iconAsset, width: 28.w, height: 28.w),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryText,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      option.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black87,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator:
              validator ??
              (value) {
                if (value == null || value.trim().isEmpty) return 'Required';
                return null;
              },
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black87,
            fontSize: 13.sp,
          ),
          decoration: InputDecoration(
            hintText: 'Enter here',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black38,
              fontSize: 13.sp,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            border: _fieldBorder(),
            enabledBorder: _fieldBorder(),
            focusedBorder: _fieldBorder(AppColors.primaryText),
            errorBorder: _fieldBorder(Colors.redAccent),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _fieldBorder([Color color = AppColors.accent]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.r),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Colors.black,
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DetailBottomNav extends StatelessWidget {
  const _DetailBottomNav();

  static const _items = [
    ('Today', 'assets/home/navToday.png'),
    ('Calendar', 'assets/home/navCalendar.png'),
    ('My Bundle', 'assets/home/navBundles.png'),
    ('Life Events', 'assets/home/navLifeEvents.png'),
  ];

  void _onTap(BuildContext context, int index) {
    // Pop back to AppShell and switch to the selected tab
    Navigator.of(context).popUntil((route) => route.isFirst);
    // After popping, notify AppShell via a post-frame callback isn't possible
    // directly, so we replace the root with AppShell at the desired index
    Navigator.of(context).pushReplacementNamed('/', arguments: index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.primaryText),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              for (final entry in _items.indexed)
                Expanded(
                  child: InkWell(
                    onTap: () => _onTap(context, entry.$1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage(entry.$2.$2),
                          color: entry.$1 == 0
                              ? AppColors.accent
                              : Colors.white,
                          size: 21.sp,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          entry.$2.$1,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: entry.$1 == 0
                                    ? AppColors.accent
                                    : Colors.white,
                                fontSize: 10.sp,
                                height: 1,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyOption {
  const _JourneyOption({
    required this.title,
    required this.subtitle,
    required this.iconAsset,
  });

  final String title;
  final String subtitle;
  final String iconAsset;
}
