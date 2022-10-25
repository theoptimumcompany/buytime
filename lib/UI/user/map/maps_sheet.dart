/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

class MapsSheet {
  static show({
    BuildContext context,
    Function(AvailableMap map) onMapTap,
  }) async {
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(SizeConfig.safeBlockHorizontal * 5),
              topLeft: Radius.circular(SizeConfig.safeBlockHorizontal * 5)
          )
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConfig.safeBlockHorizontal * 5),
                topLeft: Radius.circular(SizeConfig.safeBlockHorizontal * 5)
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: CustomScrollView(shrinkWrap: true, slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          //MenuItemModel menuItem = menuItems.elementAt(index);
                          var map = availableMaps.elementAt(index);
                          return ListTile(
                            onTap: () => onMapTap(map),
                            title: Text(map.mapName),
                            leading: SvgPicture.asset(
                              map.icon,
                              height: 30.0,
                              width: 30.0,
                            ),
                          );
                          // return InkWell(
                          //   onTap: () {
                          //     debugPrint('Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
                          //   },
                          //   //child: MenuItemListItemWidget(menuItem),
                          //   child: CategoryListItemWidget(categoryItem),
                          // );
                        },
                        childCount: availableMaps.length,
                      ),
                    ),
                  ]),
                ),
                /*Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Wrap(
                        children: <Widget>[
                          for (var map in availableMaps)
                            ListTile(
                              onTap: () => onMapTap(map),
                              title: Text(map.mapName),
                              leading: SvgPicture.asset(
                                map.icon,
                                height: 30.0,
                                width: 30.0,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        );
      },
    );
  }
}
