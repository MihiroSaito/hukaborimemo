import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hukaborimemo/pages/setting_page/setting_viewmodel.dart';
import 'package:hukaborimemo/setting/setting_menus.dart';

PreferredSizeWidget settingAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(55.0),
    child: AppBar(
      backgroundColor: Theme.of(context).cardTheme.color,
      shadowColor: Colors.black.withOpacity(0.2),
      title: Text(
        '設定',
        style: TextStyle(
            fontSize: 17
        ),
      ),
      centerTitle: true,
      leading: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              CupertinoIcons.chevron_back,
              color: Color(0xFF868E96),
              size: 25,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget settingContents(BuildContext context) {

  final windowSize = MediaQuery.of(context).size;

  return Column(
    children: [
      SizedBox(height: 50,),
      Container(
        width: windowSize.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 0),
            )
          ]
        ),
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeTop: true,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
              return Material(
                child: InkWell(
                  onTap: () {
                    settingFunctions(
                        settingTitle: SettingClass.settingMenus[index]['title']);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            SettingClass.settingMenus[index]['icon'],

                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: (SettingClass.settingMenus.length-1) != index? 1 : 0,
                                        color: Theme.of(context).indicatorColor
                                    )
                                )
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${SettingClass.settingMenus[index]['title']}',
                                style: TextStyle(
                                  fontSize: 16
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: SettingClass.settingMenus.length,
          ),
        ),
      ),
      Container(
        width: windowSize.width,
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'version 1.0.0',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6!.color
            ),
          ),
        ),
      )
    ],
  );
}
