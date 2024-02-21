import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:geolocator/geolocator.dart';

class NoLocationScreen extends StatelessWidget {
  const NoLocationScreen({Key? key, required this.isPermanentDenied, required this.isServiceDisabled}) : super(key: key);
  final bool isPermanentDenied;
  final bool isServiceDisabled;

  @override
  Widget build(BuildContext context) {
    return showDialog(context);
  }
  showDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('You need to turn on location to view nearest ads.',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey.shade600,
              ),),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        height: 35,

                        color: PsColors.activeColor,
                        child: Text(
                          Utils.getString(context, 'chat_view__accept_cancel_button'),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                              color: PsColors.baseColor,
                              fontWeight: FontWeight.bold),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          exit(0);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Flexible(flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        height: 35,
                        color: PsColors.activeColor,
                        child: Text(
                          Utils.getString(context, 'dialog__ok'),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                              color: PsColors.baseColor,
                              fontWeight: FontWeight.bold),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () async {
                          try{
                            final LocationPermission status = await Geolocator.checkPermission();
                              if(status== LocationPermission.denied||status== LocationPermission.deniedForever){
                                final bool opened = await Geolocator.openAppSettings();
                                if(opened){
                                  if(await Geolocator.isLocationServiceEnabled()){
                                    Navigator.pop(context,true);
                                  }else{
                                    Geolocator.openLocationSettings();
                                  }
                                }else{
                                  exit(0);
                                }
                              }
                              await Geolocator.getCurrentPosition();
                              Navigator.pop(context, true);

                          }catch(e){
                            if(!await Geolocator.isLocationServiceEnabled()){
                              Geolocator.openLocationSettings();
                            }else{
                              Geolocator.openAppSettings();
                            }
                          }
                          // if(isServiceDisabled){
                          //   Geolocator.openLocationSettings();
                          //   // exit(0);
                          // }else if (isPermanentDenied){
                          //   Geolocator.openAppSettings();
                          //   // exit(0);
                          // }else{
                          //   final LocationPermission status = await Geolocator.requestPermission();
                          //   if(status== LocationPermission.denied||status== LocationPermission.deniedForever){
                          //     Geolocator.openAppSettings();
                          //     exit(0);
                          //   }
                          // }
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],),
        ),
      ),
    );
  }
}
