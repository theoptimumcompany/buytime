
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ConventionHelper{

  bool getConvention(ServiceState service, List<BookingState> bookingList, BuildContext context){
    bool isConvention = false;
    String businessId = Provider.of<Explorer>(context, listen: false).businessState.id_firestore;//bookingList.isNotEmpty ? checkActiveBooking(bookingList) : '';
    //debugPrint('convention_helper => CONVENTION BUSINESS ID: $businessId');
    if(service.hubConvention && service.conventionSlotList.isNotEmpty){
      if(service.conventionSlotList.first.hubId == 'allHubs'){
        isConvention = true;
      }else{
        service.conventionSlotList.forEach((convention) {
          //debugPrint('convention_helper => CONVENTION SERIVCE HUB ID: ${convention.hubId}');
          if(convention.hubId == businessId){
            //debugPrint('convention_helper => CONVENTION FOUND');
            isConvention = true;
          }
        });
      }
    }
    //debugPrint('convention_helper => FINAL CONVENTION FOR $businessId IS $isConvention');
    return isConvention;
  }

  String checkActiveBooking(List<BookingState> bookingList) {
    String businessId = '';
    //debugPrint('convention_helper => FIST BOOKING STATUS: ${bookingList.first.status}');
    if(bookingList.first.status == Utils.enumToString(BookingStatus.opened))
       businessId = bookingList.first.business_id;
    return businessId;
  }

  int getConventionDiscount(ServiceState service, String businessId){
    int discount = 0;
    //debugPrint('convention_helper => CONVENTION DISCOUNT BUSINESS ID: $businessId');
    if(service.conventionSlotList.isNotEmpty){
      if(service.conventionSlotList.first.hubId == 'allHubs'){
        discount = service.conventionSlotList.first.discount;
      }else{
        service.conventionSlotList.forEach((convention) {
          //debugPrint('convention_helper => CONVENTION DISCOUNT SERIVCE HUB ID: ${convention.hubId}');
          if(convention.hubId == businessId){
            //debugPrint('convention_helper => CONVENTION DISCOUNT FOUND');
            discount = convention.discount;
          }
        });
      }

    }
    //debugPrint('convention_helper => FINAL CONVENTION DISCOUNT FOR $businessId IS $discount');
    return discount;
  }
}