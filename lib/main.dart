import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tukangku/blocs/auth_bloc/auth_bloc.dart';
import 'package:tukangku/blocs/banner_bloc/banner_bloc.dart';
import 'package:tukangku/blocs/category_service_bloc/category_service_bloc.dart';
import 'package:tukangku/blocs/design_bloc/design_bloc.dart';
import 'package:tukangku/blocs/employee_bloc/employee_bloc.dart';
import 'package:tukangku/blocs/home_bloc/home_bloc.dart';
import 'package:tukangku/blocs/profile_bloc/profile_bloc.dart';
import 'package:tukangku/blocs/service_bloc/service_bloc.dart';
import 'package:tukangku/screens/account/master/banner/master_banner.dart';
import 'package:tukangku/screens/account/master/banner/master_banner_create.dart';
import 'package:tukangku/screens/account/master/category/master_category_service.dart';
import 'package:tukangku/screens/account/master/category/master_category_service_create.dart';
import 'package:tukangku/screens/account/master/consumen/master_consumen.dart';
import 'package:tukangku/screens/account/master/employee/master_employee.dart';
import 'package:tukangku/screens/account/master/employee/master_employee_create.dart';
import 'package:tukangku/screens/account/master/gps_log/master_gps_log.dart';
import 'package:tukangku/screens/account/master/payment/master_payment.dart';
import 'package:tukangku/screens/account/master/service/master_service.dart';
import 'package:tukangku/screens/account/master/transaction/master_transaction.dart';
import 'package:tukangku/screens/account/master/transaction/master_transaction_detail.dart';
import 'package:tukangku/screens/account/master/user/master_user.dart';
import 'package:tukangku/screens/account/master/user/master_user_log.dart';
import 'package:tukangku/screens/account/master/user_role/master_user_permission.dart';
import 'package:tukangku/screens/account/master/user_role/master_user_role.dart';
import 'package:tukangku/screens/account/profile/update_password.dart';
import 'package:tukangku/screens/account/profile/update_profile.dart';
import 'package:tukangku/screens/auth/login.dart';
import 'package:tukangku/screens/auth/register.dart';
import 'package:tukangku/screens/navbar.dart';
import 'package:tukangku/screens/others/filter.dart';
import 'package:tukangku/screens/others/map_coordinate.dart';
import 'package:tukangku/screens/others/search.dart';
import 'package:tukangku/screens/transaction/cart.dart';
import 'package:tukangku/screens/transaction/payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tukangku/screens/widgets/image_cropper.dart';

void main() async {
  await dotenv.load(fileName: "assets/env/.env_production");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => HomeBloc(),
        ),
        BlocProvider<DesignBloc>(
          create: (BuildContext context) => DesignBloc(),
        ),
        BlocProvider<ServiceBloc>(
          create: (BuildContext context) => ServiceBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (BuildContext context) => ProfileBloc(),
        ),
        BlocProvider<BannerBloc>(
          create: (BuildContext context) => BannerBloc(),
        ),
        BlocProvider<EmployeeBloc>(
          create: (BuildContext context) => EmployeeBloc(),
        ),
        BlocProvider<CategoryServiceBloc>(
          create: (BuildContext context) => CategoryServiceBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Tukangku',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        builder: EasyLoading.init(),
        routes: {
          '/': (context) => MyHomePage(),
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/navbar': (context) => Navbar(),
          '/search': (context) => Search(),
          '/filter': (context) => Filter(),
          '/cart': (context) => Cart(),
          '/update-profile': (context) => UpdateProfil(),
          '/update-password': (context) => UpdatePassword(),
          '/master-service': (context) => MasterService(),
          '/master-service-category': (context) => MasterCategoryService(),
          '/master-service-category-create': (context) =>
              MasterCategoryServiceCreate(),
          '/master-employee': (context) => MasterEmployee(),
          '/master-employee-create': (context) => MasterEmployeeCreate(),
          '/master-banner': (context) => MasterBanner(),
          '/master-banner-create': (context) => MasterBannerCreate(),
          '/master-consumen': (context) => MasterConsumen(),
          '/master-user': (context) => MasterUser(),
          '/master-user-log': (context) => MasterUserLog(),
          '/master-user-role': (context) => MasterUserRole(),
          '/master-user-permission': (context) => MasterUserPermission(),
          '/master-transaction': (context) => MasterTransaction(),
          '/master-transaction-detail': (context) => MasterTransactionDetail(),
          '/master-payment': (context) => MasterPayment(),
          '/master-gps-log': (context) => MasterGPSLog(),
          '/payment': (context) => Payment(),
          '/map-coordinate': (context) => MapCoordinate(),
          '/image-cropper': (context) => ImageCropper(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(GetAuthData());
    super.initState();
  }

  // @override
  // void dispose() {
  //   authBloc.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authorized) {
          // Navigator.of(context).popAndPushNamed('/navbar');
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const Navbar()),
            ModalRoute.withName('/navbar'),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Selamat Datang di Tukangku',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: Colors.orangeAccent.shade700),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Image.network(
                          'https://cdni.iconscout.com/illustration/premium/thumb/office-staff-discussing-creative-and-innovative-solution-2710133-2268505.png'),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          width: size.width,
                          child: TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/login'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Sign in',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.orangeAccent.shade700),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: size.width,
                          child: TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/register'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Colors.orangeAccent.shade700),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.orangeAccent.shade700,
                                  width: 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'By using our mobile app, you agree with our Terms of Use and Privacy Policy',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.black87, fontSize: 12),
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
      ),
    );
  }
}
