
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class ConventionHelper{

  bool getConvention(ServiceState service, List<BookingState> bookingList){
    bool isConvention = false;
    String businessId = checkActiveBooking(bookingList);
    debugPrint('CONVENTION BUSINESS ID: $businessId');
    if(service.hubConvention && service.conventionSlotList.isNotEmpty){
      if(service.conventionSlotList.first.hubId == 'allHubs'){
        isConvention = true;
      }else{
        service.conventionSlotList.forEach((convention) {
          debugPrint('CONVENTION SERIVCE HUB ID: ${convention.hubId}');
          if(convention.hubId == businessId){
            debugPrint('CONVENTION FOUND');
            isConvention = true;
          }
        });
      }
    }
    debugPrint('FINAL CONVENTION FOR $businessId IS $isConvention');
    return isConvention;
  }

  String checkActiveBooking(List<BookingState> bookingList) {
    String businessId = '';
    debugPrint('FIST BOOKING STATUS: ${bookingList.first.status}');
    if(bookingList.first.status == Utils.enumToString(BookingStatus.opened))
       businessId = bookingList.first.business_id;
    return businessId;
  }

  int getConventionDiscount(ServiceState service, String businessId){
    int discount = 0;
    debugPrint('CONVENTION DISCOUNT BUSINESS ID: $businessId');
    if(service.conventionSlotList.isNotEmpty){
      if(service.conventionSlotList.first.hubId == 'allHubs'){
        discount = service.conventionSlotList.first.discount;
      }else{
        service.conventionSlotList.forEach((convention) {
          debugPrint('CONVENTION DISCOUNT SERIVCE HUB ID: ${convention.hubId}');
          if(convention.hubId == businessId){
            debugPrint('CONVENTION DISCOUNT FOUND');
            discount = convention.discount;
          }
        });
      }

    }
    debugPrint('FINAL CONVENTION DISCOUNT FOR $businessId IS $discount');
    return discount;
  }
}