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
                  child: CustomScrollView(
                      physics: new ClampingScrollPhysics(),
                      shrinkWrap: true, slivers: [
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
                          //     debugPrint('maps_sheet => Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
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
