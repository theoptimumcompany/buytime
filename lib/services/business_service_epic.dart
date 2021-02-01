import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';

import 'package:Buytime/services/file_upload_service.dart'
    if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class BusinessListRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BusinessListRequest>().asyncMap((event) async {
      print("BusinessListService user id:" + event.userId);
      List<BusinessState> businessStateList = List<BusinessState>();
      var businessListFromFirebase;
      if (event.userId == "any") {
        businessListFromFirebase = await FirebaseFirestore.instance
            .collection("business")
            .where("draft", isEqualTo: false)
            .limit(10)
            .get();
      } else {
        if (event.role == Role.manager) {
          businessListFromFirebase = await FirebaseFirestore.instance // TODO we have to be sure about this
              .collection("business")
              .where("hasAccess", arrayContains: store.state.user.email) // TODO check that arrayContains is ok here
              .limit(10)
              .get();
        }if (event.role == Role.owner) {
          businessListFromFirebase = await FirebaseFirestore.instance
              .collection("business")
              .where("ownerId", isEqualTo: store.state.user.uid)
              .limit(10)
              .get();
        } else if (event.role == Role.salesman) {
          businessListFromFirebase = await FirebaseFirestore.instance
              .collection("business")
              .where("salesmanId", isEqualTo: store.state.user.uid)
              .limit(10)
              .get();
        } else if (event.role == Role.admin) {
          businessListFromFirebase =
              await FirebaseFirestore.instance.collection("business").limit(10).get();
        }
      }
      businessListFromFirebase.docs.forEach((element) {
        BusinessState businessState = BusinessState.fromJson(element.data());
        businessState.id_firestore = element.id;
        print("business_service_epic : ID doc -> " + element.id);
        businessStateList.add(businessState);
      });
      return new BusinessListReturned(businessStateList);
    });
  }
}

class BusinessRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BusinessRequest>().asyncMap((event) {
      print("BusinessService document id:" + event.businessStateId);
      return FirebaseFirestore.instance
          .collection("business")
          .doc(event.businessStateId)
          .get()
          .then((snapshot) {
        print("BusinessService firestore listener:" + snapshot.get('name'));
        return new BusinessRequestResponse(BusinessState(
          name: snapshot.get('name'),
          responsible_person_name: snapshot.get('responsible_person_name'),
          responsible_person_surname: snapshot.get('responsible_person_surname'),
          responsible_person_email: snapshot.get('responsible_person_email'),
          phone_number: snapshot.get('phone_number') ?? '000 000 0000',
          email: snapshot.get('email'),
          VAT: snapshot.get('VAT'),
          street: snapshot.get('street'),
          municipality: snapshot.get('municipality'),
          street_number: snapshot.get('street_number'),
          ZIP: snapshot.get('ZIP'),
          state_province: snapshot.get('state_province'),
          nation: snapshot.get('nation'),
          coordinate: snapshot.get('coordinate'),
          profile: snapshot.get('profile'),
          gallery: List<String>.from(snapshot.get('gallery')),
          wide: snapshot.get('wide'),
          logo: snapshot.get('logo'),
          business_type: List<GenericState>.from(snapshot.get('business_type')),
          description: snapshot.get('description'),
          id_firestore: snapshot.get('id_firestore'),
          salesmanId: snapshot.get('salesmanId'),
          ownerId: snapshot.get('salesmanId'),
        ));
      });
    }).takeUntil(actions.whereType<UnlistenBusiness>());
  }
}

BusinessState businessStateImageLinksUpdate(
    BusinessState businessState, OptimumFileToUpload fileToUpload, String fileUrl) {
  return businessState;
}

Future<BusinessState> uploadFiles(
    List<OptimumFileToUpload> fileToUploadList, BusinessState businessState) async {
  await Future.forEach(
      fileToUploadList,
      (fileToUpload) => uploadToFirebaseStorage(fileToUpload).then((fileUrl) {
            if (fileToUpload.remoteFolder.contains("logo")) {
              businessState.logo = fileUrl.toString();
            } else if (fileToUpload.remoteFolder.contains("wide")) {
              businessState.wide = fileUrl.toString();
            } else if (fileToUpload.remoteFolder.contains("profile")) {
              businessState.profile = fileUrl.toString();
            } else if (fileToUpload.remoteFolder.contains("gallery")) {
              businessState.gallery[0] = fileUrl.toString();
            }
            return businessState;
          }));
  return businessState;
}

class BusinessUpdateService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    print("BusinessService call of update");
    return actions.whereType<UpdateBusiness>().asyncMap((event) async {
      if (event.businessState.fileToUploadList != null) {
        // TODO at the moment the upload error is not managed
        uploadFiles(event.businessState.fileToUploadList, event.businessState)
            .then((BusinessState updatedBusinessState) {
          return updateBusiness(updatedBusinessState);
        });
      }
      return updateBusiness(event.businessState);
    }).takeUntil(actions.whereType<UnlistenBusiness>());
  }
}

class BusinessCreateService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateBusiness>().asyncMap((event) async {
      BusinessState businessState = event.businessState;


      if (businessState.business_type.isNotEmpty && businessState.business_type[0].toString().isEmpty &&
          businessState.business_type.length > 1) {
        businessState.business_type = businessState.business_type.sublist(1);
      }
      if (store.state.user.salesman) {
        businessState.salesmanId = store.state.user.uid;
      } else {
        businessState.ownerId = store.state.user.uid;
      }

      if (event.businessState.fileToUploadList != null) {
        await uploadFiles(event.businessState.fileToUploadList, event.businessState)
            .then((BusinessState updatedBusinessState) {
          print("BusinessServiceEpic: uploadFiles executed.");
          return createBusiness(updatedBusinessState);
        }).catchError((error, stackTrace) {
          print("BusinessServiceEpic: uploadFiles failed: $error");
          return null;
        });
      } else {
        return createBusiness(businessState);
      }
    });
  }
}

Future<CreatedBusiness> createBusiness(BusinessState businessState) {
  var docReference = FirebaseFirestore.instance.collection("business").doc();
  businessState.id_firestore = docReference.id;
  return docReference.set(businessState.toJson()).then((value) {
    print("BusinessService has created new Business! ");
    return new CreatedBusiness(businessState);
  });
}

Future<UpdatedBusiness> updateBusiness(BusinessState businessState) {
  return FirebaseFirestore.instance
      .collection("business")
      .doc(businessState.id_firestore)
      .update(businessState.toJson())
      .then((value) {
    print("BusinessService should be updated online ");
    return new UpdatedBusiness(businessState);
  });
}
