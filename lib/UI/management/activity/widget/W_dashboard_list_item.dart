import 'package:Buytime/UI/management/activity/UI_M_activity_management_item_details.dart';
import 'package:Buytime/UI/management/invite/UI_M_booking_details.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:Buytime/reusable/material_design_icons.dart';

class DashboardListItem extends StatefulWidget {

  OrderState orderState;
  OrderEntry orderEntry;
  DashboardListItem(this.orderState, this.orderEntry);

  @override
  _DashboardListItemState createState() => _DashboardListItemState();
}

class _DashboardListItemState extends State<DashboardListItem> {

  BookingState booking;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: BuytimeTheme.BackgroundWhite,
      height: 75,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.black.withOpacity(.3),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityManagementItemDetails(orderState: widget.orderState, orderEntry: widget.orderEntry,)),);
          },
          //borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Row(
            children: [
              ///Icon
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                    child: Icon(
                      widget.orderState.progress == Utils.enumToString(OrderStatus.canceled) || widget.orderState.progress == Utils.enumToString(OrderStatus.declined)  ? BuytimeIcons.pending_clock : BuytimeIcons.accepted_clock,
                      color:
                      widget.orderState.progress == Utils.enumToString(OrderStatus.canceled) || widget.orderState.progress == Utils.enumToString(OrderStatus.declined) ?
                      BuytimeTheme.AccentRed :
                      widget.orderState.progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout) ?
                      BuytimeTheme.Secondary : BuytimeTheme.SymbolBlack,
                      size: 22,
                    ),
                  )
                ],
              ),
              ///Order info
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Name ecc.
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                              widget.orderState.selected == null || widget.orderState.selected.isEmpty ?
                            '${widget.orderState.user.name ?? ''} ${widget.orderState.user.surname ?? ''}' :
                            '${widget.orderState.user.name ?? ''} ${widget.orderState.user.surname ?? ''} - ${widget.orderEntry.time}',
                            style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                fontSize: 16,
                                letterSpacing: 0.15,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ///Service Name & Price
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                              widget.orderState.selected == null || widget.orderState.selected.isEmpty ?
                              '${AppLocalizations.of(context).currency} ${widget.orderState.total.toStringAsFixed(2)}' :
                              '${Utils.retriveField(Localizations.localeOf(context).languageCode, widget.orderEntry.name)} - € ${widget.orderEntry.price.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                fontSize: 14,
                                letterSpacing: 0.25,
                                fontWeight: FontWeight.w400,
                              color: BuytimeTheme.TextMedium
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ///Status
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            widget.orderState.progress == Utils.enumToString(OrderStatus.progress) ?
                            '${AppLocalizations.of(context).progress}' :
                            widget.orderState.progress == Utils.enumToString(OrderStatus.unpaid) ?
                            '${AppLocalizations.of(context).unpaid}' :
                            widget.orderState.progress == Utils.enumToString(OrderStatus.accepted) ?
                            '${AppLocalizations.of(context).accepted}' :
                            widget.orderState.progress == Utils.enumToString(OrderStatus.paid) ?
                            '${AppLocalizations.of(context).paid}' :
                            widget.orderState.progress == Utils.enumToString(OrderStatus.pending) ?
                            '${AppLocalizations.of(context).pending}' :
                            widget.orderState.progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout) ?
                            '${AppLocalizations.of(context).toBePaidAtCheckout}' :
                            widget.orderState.progress == Utils.enumToString(OrderStatus.canceled) ?
                            '${AppLocalizations.of(context).canceled}' :
                            widget.orderState.progress == Utils.enumToString(OrderStatus.frozen) ?
                            '${AppLocalizations.of(context).frozen}' :
                            widget.orderState.progress == Utils.enumToString(OrderStatus.declined) ?
                            '${AppLocalizations.of(context).declined}' :
                            widget.orderState.progress == Utils.enumToString(OrderStatus.creating) ?
                            '${AppLocalizations.of(context).creating}' : '???',
                            style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                fontSize: 12,
                                letterSpacing: 0.25,
                                fontWeight: FontWeight.w400,
                                color: BuytimeTheme.TextMedium,
                              fontStyle: FontStyle.italic
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}

