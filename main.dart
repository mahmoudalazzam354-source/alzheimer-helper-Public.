import 'package:flutter/material.dart';

void main() => runApp(const AlzheimerHelperApp());

const purple = Color(0xFF5422B8);
const lavender = Color(0xFFF2ECFF);

class AlzheimerHelperApp extends StatelessWidget {
  const AlzheimerHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مساعد الزهايمر',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        scaffoldBackgroundColor: const Color(0xFFFCFAFF),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: purple,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const MainShell(),
    );
  }
}

class SavedItem {
  SavedItem(this.name, this.place, this.updated);
  final String name;
  String place;
  String updated;
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  final items = <SavedItem>[
    SavedItem('النظارة', 'طاولة غرفة الجلوس', 'اليوم، 10:00 صباحاً'),
    SavedItem('المفاتيح', 'الرف قرب باب المنزل', 'اليوم، 9:30 صباحاً'),
    SavedItem('المحفظة', 'درج غرفة النوم', 'أمس، 8:15 مساءً'),
  ];

  void addItem() async {
    final name = TextEditingController();
    final place = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة غرض', textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: 'اسم الغرض')),
            TextField(controller: place, textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: 'أين وضعته؟')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, true),
            child: const Text('حفظ')),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty && place.text.trim().isNotEmpty) {
      setState(() => items.insert(0,
        SavedItem(name.text.trim(), place.text.trim(), 'تمت الإضافة الآن')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onSearch: () => setState(() => tab = 1),
        onItems: () => setState(() => tab = 2),
        onFamily: () => setState(() => tab = 3)),
      SearchPage(items: items),
      ItemsPage(items: items, onAdd: addItem),
      const FamilyPage(),
      const SettingsPage(),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مساعد الزهايمر',
          style: TextStyle(fontWeight: FontWeight.bold))),
        body: pages[tab],
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.search), label: 'بحث'),
            NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'أغراضي'),
            NavigationDestination(icon: Icon(Icons.people_outline), label: 'العائلة'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'الإعدادات'),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onSearch, required this.onItems, required this.onFamily});
  final VoidCallback onSearch, onItems, onFamily;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [purple, Color(0xFF8556D8)]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.psychology_alt_outlined, color: Colors.white, size: 42),
          SizedBox(height: 12),
          Text('أهلاً بك', style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('أنا هنا لمساعدتك في العثور على أغراضك.',
            style: TextStyle(color: Colors.white, fontSize: 17)),
        ]),
      ),
      const SizedBox(height: 20),
      _ActionTile(icon: Icons.search, title: 'ابحث عن غرض', subtitle: 'بالصوت أو الصورة أو الكتابة', onTap: onSearch),
      _ActionTile(icon: Icons.inventory_2_outlined, title: 'أغراضي المحفوظة', subtitle: 'شاهد الأماكن التي سجلتها', onTap: onItems),
      _ActionTile(icon: Icons.people_alt_outlined, title: 'تواصل مع العائلة', subtitle: 'اطلب المساعدة من شخص تثق به', onTap: onFamily),
      const SizedBox(height: 10),
      const Text('تذكير اليوم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const Card(child: ListTile(leading: Icon(Icons.notifications_active, color: purple),
        title: Text('تذكير بمراجعة قائمة الأغراض'), subtitle: Text('يمكن للعائلة تعديل التذكيرات'))),
    ],
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      leading: CircleAvatar(backgroundColor: lavender, foregroundColor: purple,
        radius: 26, child: Icon(icon, size: 28)),
      title: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.chevron_left),
      onTap: onTap,
    ),
  );
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.items});
  final List<SavedItem> items;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  SavedItem? result;
  String message = '';

  void search() {
    final q = controller.text.trim();
    setState(() {
      result = widget.items.where((e) => e.name.contains(q) && q.isNotEmpty).firstOrNull;
      message = result == null
        ? 'لم نعثر على غرض بهذا الاسم في القائمة المسجلة.'
        : 'آخر مكان مسجل لهذا الغرض:';
    });
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('ماذا تبحث عنه؟', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('اكتب اسم الغرض، أو استخدم إحدى طرق البحث.', style: TextStyle(fontSize: 16)),
      const SizedBox(height: 18),
      TextField(controller: controller, textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'مثلاً: النظارة',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onSubmitted: (_) => search()),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: search, icon: const Icon(Icons.search), label: const Text('ابحث')),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: () => _showInfo(context, 'البحث الصوتي',
          'سيتم ربط هذه الواجهة بخدمة تحويل الكلام إلى نص بعد إضافة إذن الميكروفون.'),
        icon: const Icon(Icons.mic), label: const Text('ابحث بصوتك')),
      OutlinedButton.icon(
        onPressed: () => _showInfo(context, 'البحث بالصورة',
          'سيتم تفعيل الكاميرا واختيار الصور وربطها بالتعرف على الأغراض في مرحلة التكامل.'),
        icon: const Icon(Icons.camera_alt_outlined), label: const Text('ابحث بصورة')),
      if (message.isNotEmpty) ...[
        const SizedBox(height: 20),
        Card(color: lavender, child: Padding(
          padding: const EdgeInsets.all(18),
          child: result == null
            ? Text(message, style: const TextStyle(fontSize: 17))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                Text(message, style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 8),
                Text(result!.name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Text(result!.place, style: const TextStyle(fontSize: 19)),
                Text(result!.updated, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),
                const Text('هذه آخر معلومة مسجلة وليست تتبعاً مباشراً للغرض.'),
              ]),
        )),
      ],
    ],
  );
}

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key, required this.items, required this.onAdd});
  final List<SavedItem> items;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('أغراضي', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        FilledButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('إضافة')),
      ]),
      const SizedBox(height: 12),
      for (final item in items)
        Card(child: ListTile(
          leading: const CircleAvatar(backgroundColor: lavender, child: Icon(Icons.category, color: purple)),
          title: Text(item.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          subtitle: Text('${item.place}\n${item.updated}'),
          isThreeLine: true,
        )),
      const SizedBox(height: 8),
      const Text('ملاحظة: هذه البيانات محفوظة داخل النموذج التجريبي فقط.',
        style: TextStyle(color: Colors.black54)),
    ],
  );
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('العائلة', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    const Card(child: ListTile(leading: CircleAvatar(child: Icon(Icons.person)),
      title: Text('ربط أحد أفراد العائلة'), subtitle: Text('سيتم تفعيل الدعوات الآمنة في النسخة المتصلة'))),
    FilledButton.icon(onPressed: () => _showInfo(context, 'دعوة العائلة',
      'تتطلب هذه الميزة تسجيل الدخول وخدمة خلفية لإرسال الدعوات.'), icon: const Icon(Icons.person_add), label: const Text('إضافة فرد من العائلة')),
    const SizedBox(height: 16),
    const Text('لن تتم مشاركة موقع المريض أو بياناته إلا بموافقته أو بموافقة ممثله المخوّل.'),
  ]);
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('الإعدادات وإمكانية الوصول', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SwitchListTile(value: true, onChanged: null, title: Text('خط كبير'), subtitle: Text('إعداد توضيحي')),
    const SwitchListTile(value: true, onChanged: null, title: Text('واجهة عربية'), subtitle: Text('من اليمين إلى اليسار')),
    ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: const Text('الخصوصية والصلاحيات'),
      onTap: () => _showInfo(context, 'الخصوصية', 'سيتم بناء إعدادات الموافقة والصلاحيات قبل ربط الحسابات الحقيقية.')),
    ListTile(leading: const Icon(Icons.help_outline), title: const Text('المساعدة')),
  ]);
}

void _showInfo(BuildContext context, String title, String body) {
  showDialog<void>(context: context, builder: (context) => AlertDialog(
    title: Text(title, textAlign: TextAlign.right),
    content: Text(body, textAlign: TextAlign.right),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
  ));
}

extension FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
