// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/user_model.dart';
// import '../../providers/auth_provider.dart';
// import '../../routes.dart';
//
// class AuthScreen extends StatefulWidget {
//   const AuthScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;
//   late final TextEditingController _usernameController;
//   final _formKey = GlobalKey<FormState>();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _isLogin = true;
//   var _isDj = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController(text: '');
//     _passwordController = TextEditingController(text: '');
//     _usernameController = TextEditingController(text: '');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Stack(
//         children: [
//           _buildBackground(),
//           Align(
//             alignment: Alignment.center,
//             child: _buildForm(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _usernameController.dispose();
//     super.dispose();
//   }
//
//   Widget _buildForm(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               if (!_isLogin)
//                 Column(
//                   children: [
//                     Text(
//                       _isDj
//                           ? 'I am an Entertainer'
//                           : 'I am here to make song requests!',
//                       style: TextStyle(color: Theme.of(context).primaryColor),
//                     ),
//                     const SizedBox(
//                       height: 8.0,
//                     ),
//                     Switch.adaptive(
//                       activeColor: Theme.of(context).primaryColor,
//                       value: _isDj,
//                       onChanged: (val) {
//                         setState(
//                           () {
//                             _isDj = val;
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: FlutterLogo(
//                   size: 128,
//                 ),
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 key: const ValueKey('email'),
//                 autocorrect: false,
//                 textCapitalization: TextCapitalization.none,
//                 style: Theme.of(context).textTheme.bodyText2,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter a valid email address';
//                   }
//                   return null;
//                 },
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.email,
//                       color: Theme.of(context).iconTheme.color,
//                     ),
//                     labelText: 'Email address',
//                     border: const OutlineInputBorder()),
//                 // onSaved: (value) {
//                 //   _userEmail = value!;
//                 // },
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 child: TextFormField(
//                   controller: _passwordController,
//                   key: const ValueKey('password'),
//                   obscureText: true,
//                   maxLength: 12,
//                   style: Theme.of(context).textTheme.bodyText2,
//                   validator: (value) {
//                     if (value!.isEmpty || value.length < 7) {
//                       return 'Password must be at least 7 characters long.';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.lock,
//                       color: Theme.of(context).iconTheme.color,
//                     ),
//                     labelText: 'Password',
//                     border: const OutlineInputBorder(),
//                   ),
//                   // onSaved: (value) {
//                   //   _userPassword = value!;
//                   // },
//                 ),
//               ),
//               authProvider.status == Status.authenticating
//                   ? Center(
//                       child: CircularProgressIndicator(
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     )
//                   : _isLogin
//                       ? TextButton(
//                           child: Text(
//                             'Login',
//                             style: Theme.of(context).textTheme.button,
//                           ),
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               // _formKey.currentState!.save();
//                               FocusScope.of(context).unfocus();
//
//                               bool status =
//                                   await authProvider.signInWithEmailAndPassword(
//                                       _emailController.text,
//                                       _passwordController.text);
//
//                               if (!status) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Error signing in!'),
//                                   ),
//                                 );
//                               } else {
//                                 Navigator.of(context)
//                                     .pushReplacementNamed(Routes.home);
//                               }
//                             }
//                           },
//                         )
//                       : TextButton(
//                           child: Text(
//                             'Sign Up',
//                             style: Theme.of(context).textTheme.button,
//                           ),
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               FocusScope.of(context).unfocus();
//
//                               UserModel userModel = await authProvider
//                                   .registerWithEmailAndPassword(
//                                       _emailController.text,
//                                       _passwordController.text,
//                                       _usernameController.text,
//                                       _isDj);
//
//                               if (userModel == null) {
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(const SnackBar(
//                                   content: Text('Unable to sign up!'),
//                                 ));
//                               }
//                             }
//                           },
//                         ),
//               TextButton(
//                 child: Text(
//                   _isLogin ? 'Login' : 'Sign Up',
//                 ),
//                 onPressed: () async {},
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBackground() {
//     return ClipPath(
//       clipper: SignInCustomClipper(),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height * 0.5,
//         color: Theme.of(context).iconTheme.color,
//       ),
//     );
//   }
// }
//
// class SignInCustomClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, size.height);
//
//     var firstEndPoint = Offset(size.width / 2, size.height - 95);
//     var firstControlPoint = Offset(size.width / 6, size.height * 0.45);
//
//     path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//         firstEndPoint.dx, firstEndPoint.dy);
//
//     var secondEndPoint = Offset(size.width, size.height / 2 - 50);
//     var secondControlPoint = Offset(size.width, size.height + 15);
//
//     path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//         secondEndPoint.dx, secondEndPoint.dy);
//
//     path.lineTo(size.width, size.height / 2);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }
//
// // class AuthScreen extends StatefulWidget {
// //   static const routeName = '/auth';
// //
// //   const AuthScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<AuthScreen> createState() => _AuthScreenState();
// // }
// //
// // class _AuthScreenState extends State<AuthScreen> {
// //   final _auth = FirebaseAuth.instance;
// //   final List<String> _userNamesInUse = [];
// //   var _isLoading = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchExistingUserNames();
// //   }
// //
// //   Future<void> _fetchExistingUserNames() async {
// //     print('_getUserNamesInUse Called...');
// //
// //     setState(() {
// //       _isLoading = true;
// //     });
// //     await FirebaseFirestore.instance.collection('users').get().then(
// //           (querySnapshot) => {
// //             querySnapshot.docs.forEach((doc) {
// //               _userNamesInUse.add(doc['username']);
// //             }),
// //           },
// //         );
// //     setState(() {
// //       _isLoading = false;
// //     });
// //   }
// //
// //   // Submit function to pass in to auth_form
// //   void _submitAuthForm(
// //     String email,
// //     String password,
// //     String username,
// //     bool isLogin,
// //     bool isDj,
// //     BuildContext ctx,
// //   ) async {
// //     UserCredential userCredential;
// //
// //     try {
// //       setState(() {
// //         _isLoading = true;
// //       });
// //       if (isLogin) {
// //         // Log in existing user
// //         userCredential = await _auth.signInWithEmailAndPassword(
// //             email: email, password: password);
// //       } else {
// //         // Create new user
// //         userCredential = await _auth.createUserWithEmailAndPassword(
// //             email: email, password: password);
// //
// //         await FirebaseFirestore.instance
// //             .collection('users')
// //             .doc(userCredential.user!.uid)
// //             .set(
// //           {
// //             'uid': userCredential.user!.uid,
// //             'username': username,
// //             'email': email,
// //             'isDj': isDj,
// //           },
// //         );
// //
// //         // Create firebase doc with username.
// //         // Later used to validate usernames and create routes
// //         // TODO Replace below with simple username table.
// //         // TODO This table needs to be made available to !auth in order to validate usernames
// //         await FirebaseFirestore.instance
// //             .collection('usernames')
// //             .doc(username)
// //             .set(
// //           {
// //             'uid': userCredential.user!.uid,
// //             'username': username,
// //             'email': email,
// //           },
// //         );
// //       }
// //     } on FirebaseAuthException catch (err) {
// //       String message = 'An error occurred, please check your credentials!';
// //
// //       if (err.message != null) {
// //         message = err.message!;
// //       }
// //
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         SnackBar(
// //           content: Text(message),
// //           backgroundColor: Theme.of(ctx).errorColor,
// //         ),
// //       );
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     } catch (err) {
// //       print(err);
// //       setState(() {
// //         _isLoading = true;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // backgroundColor: Theme.of(context).primaryColor,
// //       body: AuthForm(
// //         _submitAuthForm,
// //         _userNamesInUse,
// //         _isLoading,
// //       ),
// //     );
// //   }
// // }
