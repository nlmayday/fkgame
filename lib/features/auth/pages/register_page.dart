import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fkgame/core/constants/error_messages.dart';
import 'package:fkgame/core/theme/app_theme.dart';
import 'package:fkgame/features/auth/logic/auth_cubit.dart';
import 'package:fkgame/features/auth/logic/auth_state.dart';
import 'package:fkgame/core/localization/locale_cubit.dart';
import 'package:fkgame/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// 注册页面
///
/// CURSOR_RULES:
/// 1. 所有用户可见的文本必须使用 AppLocalizations.of(context) 获取
/// 2. 不允许在UI代码中硬编码中文或英文字符串
/// 3. 错误信息使用 AppLocalizations.of(context).errorMessage(key) 方法获取
/// 4. 表单验证信息使用 AppLocalizations.of(context).validationMessage(key) 方法获取
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [_buildLanguageButton()],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            // 注册成功后导航到首页
            context.go('/home');
          } else if (state.message != null) {
            // 显示错误提示
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).errorMessage(state.message!),
                ),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildRegisterForm(state),
                    const SizedBox(height: 16),
                    _buildTermsAndConditions(),
                    const SizedBox(height: 24),
                    _buildRegisterButton(state),
                    const SizedBox(height: 16),
                    _buildDivider(),
                    const SizedBox(height: 16),
                    _buildSocialRegisterButtons(),
                    const SizedBox(height: 24),
                    _buildLoginLink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.sports_esports,
            size: 48,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        // 标题
        Text(
          AppLocalizations.of(context).appName,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        // 副标题
        Text(
          AppLocalizations.of(context).register,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildRegisterForm(AuthState state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户名输入框
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).username,
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(
                  context,
                ).validationMessage('username.required');
              }
              if (value.length < 3) {
                return AppLocalizations.of(
                  context,
                ).validationMessage('username.tooShort');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // 邮箱输入框
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).email,
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(
                  context,
                ).validationMessage('email.required');
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return AppLocalizations.of(
                  context,
                ).validationMessage('email.invalid');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // 密码输入框
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).password,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(
                  context,
                ).validationMessage('password.required');
              }
              if (value.length < 6) {
                return AppLocalizations.of(
                  context,
                ).validationMessage('password.tooShort');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // 确认密码输入框
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).confirmPassword,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(
                  context,
                ).validationMessage('confirmPassword.required');
              }
              if (value != _passwordController.text) {
                return AppLocalizations.of(
                  context,
                ).validationMessage('confirmPassword.notMatch');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // 手机号输入框 (可选)
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).phone + ' (Optional)',
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                  return AppLocalizations.of(
                    context,
                  ).validationMessage('phone.invalid');
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: AppLocalizations.of(context).agreeToThe,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
              children: [
                TextSpan(
                  text: AppLocalizations.of(context).termsOfService,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          // 点击查看服务条款
                          print('Terms of Service tapped');
                        },
                ),
                TextSpan(text: ' ${AppLocalizations.of(context).and} '),
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicy,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          // 点击查看隐私政策
                          print('Privacy Policy tapped');
                        },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(AuthState state) {
    return ElevatedButton(
      onPressed:
          state.isLoading || !_agreeToTerms
              ? null
              : () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<AuthCubit>().register(
                    username: _usernameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    phone:
                        _phoneController.text.isEmpty
                            ? null
                            : _phoneController.text,
                  );
                }
              },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.5),
      ),
      child:
          state.isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
              : Text(
                AppLocalizations.of(context).register,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context).or,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialRegisterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          color: Colors.red,
          onPressed: () {
            // Google注册
          },
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: Icons.facebook,
          color: Colors.blue,
          onPressed: () {
            // Facebook注册
          },
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: Icons.apple,
          color: Colors.black,
          onPressed: () {
            // Apple注册
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon, size: 28, color: color),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).alreadyHaveAccount,
          style: TextStyle(color: Colors.grey[700]),
        ),
        TextButton(
          onPressed: () {
            // 返回登录页面
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context).login,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageButton() {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final isZh = state.locale.languageCode == 'zh';
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language, color: AppTheme.primaryColor),
          tooltip: AppLocalizations.of(context).switchLanguage,
          itemBuilder:
              (context) => [
                PopupMenuItem<String>(
                  value: 'zh',
                  child: Row(
                    children: [
                      Icon(
                        isZh
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('中文'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'en',
                  child: Row(
                    children: [
                      Icon(
                        !isZh
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('English'),
                    ],
                  ),
                ),
              ],
          onSelected: (String languageCode) {
            context.read<LocaleCubit>().changeLocale(languageCode);
          },
        );
      },
    );
  }
}
