import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _usernameController;
  String _selectedAvatar = '';
  String _selectedBackground = '';

  final List<String> _avatars = [
    'assets/avatars/avatar (1).jpg',
    'assets/avatars/avatar (2).jpg',
    'assets/avatars/avatar (3).jpg',
    'assets/avatars/avatar (4).jpg',
    'assets/avatars/avatar (5).jpg',
    'assets/avatars/avatar (6).jpg',
    'assets/avatars/avatar (7).jpg',
    'assets/avatars/avatar (8).jpg',
    'assets/avatars/default.jpg',
  ];

  final List<String> _backgrounds = [
    'assets/background/background (1).png',
    'assets/background/background (2).png',
    'assets/background/background (3).png',
    'assets/background/background (4).png',
    'assets/background/background (5).png',
    'assets/background/background (6).png',
    'assets/background/background (7).png',
    'assets/background/background (8).png',
  ];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    _usernameController = TextEditingController(text: user?.username ?? '');
    _selectedAvatar = (user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty)
        ? user.avatarUrl!
        : _avatars.first;
    _selectedBackground =
        (user?.backgroundUrl != null && user!.backgroundUrl!.isNotEmpty)
            ? user.backgroundUrl!
            : _backgrounds.first;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }

  void _submit() {
    context.read<AuthBloc>().add(
          UpdateUserProfileEvent(
            username: _usernameController.text.trim(),
            avatarUrl: _selectedAvatar,
            backgroundUrl: _selectedBackground,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Avatar:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _avatars.length,
                  itemBuilder: (context, index) {
                    final avatar = _avatars[index];
                    final isSelected = avatar == _selectedAvatar;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAvatar = avatar),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: _getImageProvider(avatar),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select Background:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _backgrounds.length,
                  itemBuilder: (context, index) {
                    final bg = _backgrounds[index];
                    final isSelected = bg == _selectedBackground;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedBackground = bg),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                )
                              : null,
                          image: DecorationImage(
                            image: _getImageProvider(bg),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    context.pop();
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Save Changes'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
