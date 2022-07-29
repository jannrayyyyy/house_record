import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general/widgets/text.dart';

import '../cubit/house/house_cubit.dart';
import 'detailscreen.dart';

import '../../core/theme/colors.dart';
import '../../dependency.dart';
import '../cubit/getrolecubit/getrole_cubit.dart';

class HouseListScreen extends StatelessWidget {
  const HouseListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: color1,
          ),
        ),
      ),
      body: BlocBuilder<HouseCubit, HouseState>(
        builder: (context, state) {
          if (state is Loaded) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBtnText(
                      '${state.houses.length.toString()} houses',
                      color: color1,
                      letterSpacing: 3,
                    ),
                  ),
                  Column(
                    children: state.houses.map((e) {
                      final phase = e.phase.split(',');
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          selectedColor: color1,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: color1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          tileColor: color3,
                          textColor: color1,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<HouseCubit>(
                                    create: (context) => sl<HouseCubit>(),
                                  ),
                                  BlocProvider<GetRoleCubit>(
                                    create: (context) => sl<GetRoleCubit>()
                                      ..getUserInFirestore(FirebaseAuth
                                              .instance.currentUser?.email ??
                                          'na'),
                                  ),
                                ],
                                child: DetailScreen(
                                  uid: e.uid,
                                  record: e,
                                ),
                              ),
                            ),
                          ),
                          title: CustomText(e.ownerName),
                          subtitle: CustomText(e.address),
                          trailing: CustomText(phase.first),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else if (state is Empty) {
            return const Align(
              alignment: Alignment.center,
              child: CustomBtnText(
                'Empty phase',
                color: color1,
              ),
            );
          } else if (state is Loading) {
            return const LinearProgressIndicator(
              color: color1,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
