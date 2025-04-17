import 'package:flutter/material.dart';
import 'package:fkgame/l10n/app_localizations.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['好友', '群组', '发现'];

  // 模拟好友数据
  final List<Map<String, dynamic>> _friends = List.generate(
    15,
    (index) => {
      'id': index + 1,
      'name': '用户${index + 1}',
      'avatar': 'https://picsum.photos/200/200?random=${index + 1}',
      'status': index % 3 == 0 ? '在线' : (index % 3 == 1 ? '游戏中' : '离线'),
      'lastActive': DateTime.now().subtract(Duration(minutes: index * 10)),
    },
  );

  // 模拟群组数据
  final List<Map<String, dynamic>> _groups = List.generate(
    8,
    (index) => {
      'id': index + 1,
      'name': '游戏群${index + 1}',
      'avatar': 'https://picsum.photos/200/200?random=${100 + index}',
      'memberCount': 10 + (index * 5),
      'lastMessage': '玩家: 大家一起来玩游戏吧！',
      'lastMessageTime': DateTime.now().subtract(Duration(minutes: index * 15)),
    },
  );

  // 模拟发现数据
  final List<Map<String, dynamic>> _discoveries = List.generate(
    10,
    (index) => {
      'id': index + 1,
      'title': '发现内容${index + 1}',
      'description': '这是一个有趣的社区发现，快来一起参与吧！',
      'image': 'https://picsum.photos/400/200?random=${200 + index}',
      'likes': 100 + (index * 20),
      'comments': 50 + (index * 10),
    },
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.social),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 搜索功能
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // 添加好友/加入群组/发布内容
              _showAddOptions(context);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsList(),
          _buildGroupsList(),
          _buildDiscoveriesList(),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('添加好友'),
                onTap: () {
                  Navigator.pop(context);
                  // 添加好友逻辑
                },
              ),
              ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('加入群组'),
                onTap: () {
                  Navigator.pop(context);
                  // 加入群组逻辑
                },
              ),
              ListTile(
                leading: const Icon(Icons.post_add),
                title: const Text('发布内容'),
                onTap: () {
                  Navigator.pop(context);
                  // 发布内容逻辑
                },
              ),
            ],
          ),
    );
  }

  Widget _buildFriendsList() {
    return ListView.builder(
      itemCount: _friends.length,
      itemBuilder: (context, index) {
        final friend = _friends[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(friend['avatar']),
            child:
                friend['status'] == '在线'
                    ? Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    )
                    : null,
          ),
          title: Text(friend['name']),
          subtitle: Text(friend['status']),
          trailing:
              friend['status'] != '离线'
                  ? IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () {
                      // 聊天功能
                    },
                  )
                  : Text(
                    '${friend['lastActive'].hour}:${friend['lastActive'].minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: Colors.grey),
                  ),
          onTap: () {
            // 查看好友资料
          },
        );
      },
    );
  }

  Widget _buildGroupsList() {
    return ListView.builder(
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(group['avatar'])),
          title: Text(group['name']),
          subtitle: Text('${group['memberCount']} 位成员'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${group['lastMessageTime'].hour}:${group['lastMessageTime'].minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          onTap: () {
            // 打开群组聊天
          },
        );
      },
    );
  }

  Widget _buildDiscoveriesList() {
    return ListView.builder(
      itemCount: _discoveries.length,
      itemBuilder: (context, index) {
        final discovery = _discoveries[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                discovery['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      discovery['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      discovery['description'],
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.favorite, size: 16, color: Colors.red),
                        const SizedBox(width: 4),
                        Text('${discovery['likes']}'),
                        const SizedBox(width: 16),
                        Icon(Icons.comment, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text('${discovery['comments']}'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // 查看详情
                          },
                          child: const Text('查看详情'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
