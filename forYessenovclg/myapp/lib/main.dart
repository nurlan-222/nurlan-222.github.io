import 'package:flutter/material.dart';

// Простая mock-auth: сохраняем в памяти
void main() {
  runApp(CollegeDuCloneApp());
}

class CollegeDuCloneApp extends StatefulWidget {
  @override
  _CollegeDuCloneAppState createState() => _CollegeDuCloneAppState();
}

class _CollegeDuCloneAppState extends State<CollegeDuCloneApp> {
  bool _loggedIn = false;
  String _userName = '';

  void _login(String name) {
    setState(() {
      _loggedIn = true;
      _userName = name;
    });
  }

  void _logout() {
    setState(() {
      _loggedIn = false;
      _userName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollegeDu Clone',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: _loggedIn
          ? MainScreen(userName: _userName, onLogout: _logout)
          : LoginScreen(onLogin: _login),
      debugShowCheckedModeBanner: false,
    );
  }
}

/* ---------------------- Login Screen ---------------------- */
class LoginScreen extends StatefulWidget {
  final void Function(String name) onLogin;
  LoginScreen({required this.onLogin});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController(text: 'Иван Иванов');

  void _tryLogin() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Введите имя')));
      return;
    }
    widget.onLogin(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
         padding: EdgeInsets.all(24),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             SizedBox(height: 48),
             FlutterLogo(size: 96),
             SizedBox(height: 24),
             Text('Добро пожаловать в CollegeDu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
             SizedBox(height: 12),
             Text('Пример учебного приложения — войдите, чтобы продолжить.', textAlign: TextAlign.center,),
             SizedBox(height: 28),
             TextField(
               controller: _controller,
               decoration: InputDecoration(labelText: 'ФИО', border: OutlineInputBorder()),
             ),
             SizedBox(height: 12),
             ElevatedButton(onPressed: _tryLogin, child: Text('Войти')),
             SizedBox(height: 16),
             Text('Или используйте тестовые данные', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
             Spacer(),
             Text('CollegEdu clone — demo', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
           ],
         ),
        ),
      ),
    );
  }
}

/* ---------------------- Main Screen ---------------------- */
class MainScreen extends StatefulWidget {
  final String userName;
  final VoidCallback onLogout;
  MainScreen({required this.userName, required this.onLogout});

  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pagesPlaceholder = <Widget>[];

  // mock-data
  final List<Course> courses = [
    Course(id: 'c1', title: 'Математика 1', teacher: 'Проф. Петров', description: 'Базовая математика: алгебра, геометрия.'),
    Course(id: 'c2', title: 'Программирование', teacher: 'Иванова А.', description: 'Введение в Dart и Flutter.'),
    Course(id: 'c3', title: 'Физика', teacher: 'Сидоров', description: 'Механика, термодинамика.')
  ];

  final List<MenuItem> menu = [
    MenuItem(name: 'Борщ', type: 'Обед', price: 350),
    MenuItem(name: 'Котлета с картошкой', type: 'Обед', price: 420),
    MenuItem(name: 'Салат из свеклы', type: 'Закуска', price: 150),
    MenuItem(name: 'Куринное филе', type: 'Ужин', price: 380),
    MenuItem(name: 'Вода 0.5л', type: 'Напитки', price: 100),
  ];

  final Map<String, List<Lecture>> schedule = {
    'Понедельник': [
      Lecture(time: '09:00 - 10:30', title: 'Математика 1', room: 'А-101'),
      Lecture(time: '11:00 - 12:30', title: 'Программирование', room: 'К-205'),
    ],
    'Вторник': [
      Lecture(time: '10:00 - 11:30', title: 'Физика', room: 'Б-303'),
    ],
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(userName: widget.userName, courses: courses),
      CoursesPage(courses: courses),
      MenuPage(menu: menu),
      SchedulePage(schedule: schedule),
      ProfilePage(userName: widget.userName, onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Курсы'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Меню'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Расписание'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}

/* ---------------------- Models ---------------------- */
class Course {
  final String id;
  final String title;
  final String teacher;
  final String description;

  Course({required this.id, required this.title, required this.teacher, required this.description});
}

class MenuItem {
  final String name;
  final String type;
  final int price;
  MenuItem({required this.name, required this.type, required this.price});
}

class Lecture {
  final String time;
  final String title;
  final String room;
  Lecture({required this.time, required this.title, required this.room});
}

/* ---------------------- Pages ---------------------- */

class HomePage extends StatelessWidget {
  final String userName;
  final List<Course> courses;
  HomePage({required this.userName, required this.courses});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(child: Text(userName.isNotEmpty ? userName[0] : 'U'), radius: 28),
              SizedBox(width: 12),
              Expanded(child: Text('Привет, $userName', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              Icon(Icons.notifications)
            ],
          ),
          SizedBox(height: 18),
          Text('Мои курсы', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
              itemBuilder: (_, i) {
                final c = courses[i];
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => CourseDetailPage(course: c)));
                    },
                    child: Card(
                      elevation: 3,
                      child: Container(
                        width: 220,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 6),
                            Text(c.teacher, style: TextStyle(color: Colors.grey[700])),
                            Spacer(),
                            Text(c.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 8),
                            Align(alignment: Alignment.bottomRight, child: Icon(Icons.arrow_forward))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 18),
          Text('Новости', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          NewsTile(title: 'Открытие новой лаборатории', subtitle: 'Вслед за обновлением кампуса...'),
          NewsTile(title: 'Расписание экзаменов', subtitle: 'Посмотреть на странице Расписание.'),
          SizedBox(height: 24),
          ElevatedButton.icon(onPressed: () {
            // quick action: go to menu
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => MenuPage(menu: [
              MenuItem(name: 'Борщ', type: 'Обед', price: 350),
              MenuItem(name: 'Котлета', type: 'Ужин', price: 420),
            ])));
          }, icon: Icon(Icons.restaurant), label: Text('Посмотреть меню столовой')),
        ],
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  NewsTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          showDialog(context: context, builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(subtitle + '\n\nПолная новость здесь (mock).'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Закрыть'))],
          ));
        },
      ),
    );
  }
}

/* ---------------------- Courses Page ---------------------- */
class CoursesPage extends StatelessWidget {
  final List<Course> courses;
  CoursesPage({required this.courses});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Text('Курсы')),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: courses.length,
        itemBuilder: (_, i) {
          final c = courses[i];
          return Card(
            child: ListTile(
              title: Text(c.title),
              subtitle: Text(c.teacher),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CourseDetailPage(course: c))),
            ),
          );
        },
      ),
    ));
  }
}

class CourseDetailPage extends StatelessWidget {
  final Course course;
  CourseDetailPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.teacher, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(course.description),
            SizedBox(height: 16),
            Text('Материалы', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Expanded(child: ListView(
              children: [
                ListTile(leading: Icon(Icons.picture_as_pdf), title: Text('Лекция 1 — Введение'), trailing: Icon(Icons.download)),
                ListTile(leading: Icon(Icons.picture_as_pdf), title: Text('Практика 1'), trailing: Icon(Icons.download)),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

/* ---------------------- Menu Page ---------------------- */
class MenuPage extends StatefulWidget {
  final List<MenuItem> menu;
  MenuPage({required this.menu});

  @override
  _MenuPageState createState() => _MenuPageState();
}
class _MenuPageState extends State<MenuPage> {
  String filter = 'Все';

  @override
  Widget build(BuildContext context) {
    final types = <String>{'Все', ...widget.menu.map((e) => e.type)};
    final shown = filter == 'Все' ? widget.menu : widget.menu.where((m) => m.type == filter).toList();

    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Text('Меню столовой')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: types.map((t) => Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(t),
                    selected: filter == t,
                    onSelected: (_) { setState(() { filter = t; }); },
                  ),
                )).toList(),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: shown.length,
                itemBuilder: (_, i) {
                  final m = shown[i];
                  return Card(
                    child: ListTile(
                      title: Text(m.name),
                      subtitle: Text('${m.type} • ${m.price}₸'),
                      trailing: ElevatedButton(
                        child: Text('Взять'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${m.name} добавлено в корзину (mock)')));
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}

/* ---------------------- Schedule Page ---------------------- */
class SchedulePage extends StatelessWidget {
  final Map<String, List<Lecture>> schedule;
  SchedulePage({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Text('Расписание')),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: schedule.entries.map((entry) {
          return Card(
            child: ExpansionTile(
              title: Text(entry.key),
              children: entry.value.map((lec) => ListTile(
                leading: Icon(Icons.access_time),
                title: Text(lec.title),
                subtitle: Text('${lec.time} • ${lec.room}'),
              )).toList(),
            ),
          );
        }).toList(),
      ),
    ));
  }
}

/* ---------------------- Profile Page ---------------------- */
class ProfilePage extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  ProfilePage({required this.userName, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 42, child: Text(userName.isNotEmpty ? userName[0] : 'U', style: TextStyle(fontSize: 32))),
            SizedBox(height: 12),
            Text(userName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Студент, группа: ИС-25-3', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            ListTile(leading: Icon(Icons.email), title: Text('email@example.com')),
            ListTile(leading: Icon(Icons.phone), title: Text('+7 700 000 0000')),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // confirm logout
                showDialog(context: context, builder: (_) => AlertDialog(
                  title: Text('Выход'),
                  content: Text('Вы действительно хотите выйти?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Отмена')),
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                      onLogout();
                    }, child: Text('Выйти')),
                  ],
                ));
              },
              icon: Icon(Icons.exit_to_app),
              label: Text('Выйти'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    ));
  }
}