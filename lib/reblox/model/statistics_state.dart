import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StatisticsState{

  ///Storage
  final storage = new FlutterSecureStorage();

  ///Booking
  int bookingCreateRequestServiceRead, bookingCreateRequestServiceWrite, bookingCreateRequestServiceDocuments;
  int bookingRequestServiceRead, bookingRequestServiceWrite, bookingRequestServiceDocuments;
  int userBookingListRequestServiceRead, userBookingListRequestServiceWrite, userBookingListRequestServiceDocuments;
  int bookingListRequestServiceRead, bookingListRequestServiceWrite, bookingListRequestServiceDocuments;
  int bookingUpdateRequestServiceRead, bookingUpdateRequestServiceWrite, bookingUpdateRequestServiceDocuments;
  int bookingUpdateAndNavigateRequestServiceRead, bookingUpdateAndNavigateRequestServiceWrite, bookingUpdateAndNavigateRequestServiceDocuments;

  ///Business
  int businessListRequestServiceRead, businessListRequestServiceWrite, businessListRequestServiceDocuments;
  int businessAndNavigateRequestServiceRead, businessAndNavigateRequestServiceWrite, businessAndNavigateRequestServiceDocuments;
  int businessAndNavigateOnConfirmRequestServiceRead, businessAndNavigateOnConfirmRequestServiceWrite, businessAndNavigateOnConfirmRequestServiceDocuments;
  int businessRequestServiceRead, businessRequestServiceWrite, businessRequestServiceDocuments;
  int businessUpdateServiceRead, businessUpdateServiceWrite, businessUpdateServiceDocuments;
  int businessCreateServiceRead, businessCreateServiceWrite, businessCreateServiceDocuments;

  ///Category Invite
  int categoryInviteRequestServiceRead, categoryInviteRequestServiceWrite, categoryInviteRequestServiceDocuments;
  int categoryInviteCreateServiceRead, categoryInviteCreateServiceWrite, categoryInviteCreateServiceDocuments;
  int categoryInviteDeleteServiceRead, categoryInviteDeleteServiceWrite, categoryInviteDeleteServiceDocuments;

  ///Category
  int categoryListRequestServiceRead, categoryListRequestServiceWrite, categoryListRequestServiceDocuments;
  int userCategoryListRequestServiceRead, userCategoryListRequestServiceWrite, userCategoryListRequestServiceDocuments;
  int categoryRootListRequestServiceRead, categoryRootListRequestServiceWrite, categoryRootListRequestServiceDocuments;
  int categoryRequestServiceRead, categoryRequestServiceWrite, categoryRequestServiceDocuments;
  int categoryInviteManagerServiceRead, categoryInviteManagerServiceWrite, categoryInviteManagerServiceDocuments;
  int categoryInviteWorkerServiceRead, categoryInviteWorkerServiceWrite, categoryInviteWorkerServiceDocuments;
  int categoryDeleteManagerServiceRead, categoryDeleteManagerServiceWrite, categoryDeleteManagerServiceDocuments;
  int categoryDeleteWorkerServiceRead, categoryDeleteWorkerServiceWrite, categoryDeleteWorkerServiceDocuments;
  int categoryUpdateServiceRead, categoryUpdateServiceWrite, categoryUpdateServiceDocuments;
  int categoryCreateServiceRead, categoryCreateServiceWrite, categoryCreateServiceDocuments;
  int categoryDeleteServiceRead, categoryDeleteServiceWrite, categoryDeleteServiceDocuments;

  ///Category Tree
  int categoryTreeCreateIfNotExistsServiceRead, categoryTreeCreateIfNotExistsServiceWrite, categoryTreeCreateIfNotExistsServiceDocuments;
  int categoryTreeRequestServiceRead, categoryTreeRequestServiceWrite, categoryTreeRequestServiceDocuments;
  int categoryTreeAddServiceRead, categoryTreeAddServiceWrite, categoryTreeAddServiceDocuments;
  int categoryTreeDeleteServiceRead, categoryTreeDeleteServiceWrite, categoryTreeDeleteServiceDocuments;
  int categoryTreeUpdateServiceRead, categoryTreeUpdateServiceWrite, categoryTreeUpdateServiceDocuments;

  ///File Upload Mobile
  int uploadToFirebaseStorageMobileRead, uploadToFirebaseStorageMobileWrite, uploadToFirebaseStorageMobileDocuments;

  ///File Upload Web
  int uploadToFirebaseStorageWebRead, uploadToFirebaseStorageWebWrite, uploadToFirebaseStorageWebDocuments;

  ///Order
  int orderListRequestServiceRead, orderListRequestServiceWrite, orderListRequestServiceDocuments;
  int orderRequestServiceRead, orderRequestServiceWrite, orderRequestServiceDocuments;
  int orderUpdateServiceRead, orderUpdateServiceWrite, orderUpdateServiceDocuments;
  int orderCreateServiceRead, orderCreateServiceWrite, orderCreateServiceDocuments;
  int orderDeleteServiceRead, orderDeleteServiceWrite, orderDeleteServiceDocuments;

  ///Pipeline
  int pipelineListRequestServiceRead, pipelineListRequestServiceWrite, pipelineListRequestServiceDocuments;
  int pipelineCreateServiceRead, pipelineCreateServiceWrite, pipelineCreateServiceDocuments;
  int pipelineRequestServiceRead, pipelineRequestServiceWrite, pipelineRequestServiceDocuments;
  int pipelineUpdateServiceRead, pipelineUpdateServiceWrite, pipelineUpdateServiceDocuments;

  ///Service
  int serviceListRequestServiceRead, serviceListRequestServiceWrite, serviceListRequestServiceDocuments;
  int serviceListAndNavigateRequestServiceRead, serviceListAndNavigateRequestServiceWrite, serviceListAndNavigateRequestServiceDocuments;
  int serviceListAndNavigateOnConfirmRequestServiceRead, serviceListAndNavigateOnConfirmRequestServiceWrite, serviceListAndNavigateOnConfirmRequestServiceDocuments;
  int serviceUpdateServiceRead, serviceUpdateServiceWrite, serviceUpdateServiceDocuments;
  int serviceUpdateServiceVisibilityRead, serviceUpdateServiceVisibilityWrite, serviceUpdateServiceVisibilityDocuments;
  int serviceCreateServiceRead, serviceCreateServiceWrite, serviceCreateServiceDocuments;

  ///Stripe
  int stripePaymentAddPaymentMethodRead, stripePaymentAddPaymentMethodWrite, stripePaymentAddPaymentMethodDocuments;
  int stripePaymentCardListRequestRead, stripePaymentCardListRequestWrite, stripePaymentCardListRequestDocuments;
  int stripeDetachPaymentMethodRequestRead, stripeDetachPaymentMethodRequestWrite, stripeDetachPaymentMethodRequestDocuments;

  ///User
  int userRequestServiceRead, userRequestServiceWrite, userRequestServiceDocuments;
  int userEditDeviceRead, userEditDeviceWrite, userEditDeviceDocuments;
  int userEditTokenRead, userEditTokenWrite, userEditTokenDocuments;


  StatisticsState({
    this.bookingCreateRequestServiceRead,
      this.bookingCreateRequestServiceWrite,
      this.bookingCreateRequestServiceDocuments,
      this.bookingRequestServiceRead,
      this.bookingRequestServiceWrite,
      this.bookingRequestServiceDocuments,
      this.userBookingListRequestServiceRead,
      this.userBookingListRequestServiceWrite,
      this.userBookingListRequestServiceDocuments,
      this.bookingListRequestServiceRead,
      this.bookingListRequestServiceWrite,
      this.bookingListRequestServiceDocuments,
      this.bookingUpdateRequestServiceRead,
      this.bookingUpdateRequestServiceWrite,
      this.bookingUpdateRequestServiceDocuments,
      this.bookingUpdateAndNavigateRequestServiceRead,
      this.bookingUpdateAndNavigateRequestServiceWrite,
      this.bookingUpdateAndNavigateRequestServiceDocuments,
      this.businessListRequestServiceRead,
      this.businessListRequestServiceWrite,
      this.businessListRequestServiceDocuments,
      this.businessAndNavigateRequestServiceRead,
      this.businessAndNavigateRequestServiceWrite,
      this.businessAndNavigateRequestServiceDocuments,
      this.businessAndNavigateOnConfirmRequestServiceRead,
      this.businessAndNavigateOnConfirmRequestServiceWrite,
      this.businessAndNavigateOnConfirmRequestServiceDocuments,
      this.businessRequestServiceRead,
      this.businessRequestServiceWrite,
      this.businessRequestServiceDocuments,
      this.businessUpdateServiceRead,
      this.businessUpdateServiceWrite,
      this.businessUpdateServiceDocuments,
      this.businessCreateServiceRead,
      this.businessCreateServiceWrite,
      this.businessCreateServiceDocuments,
      this.categoryInviteRequestServiceRead,
      this.categoryInviteRequestServiceWrite,
      this.categoryInviteRequestServiceDocuments,
      this.categoryInviteCreateServiceRead,
      this.categoryInviteCreateServiceWrite,
      this.categoryInviteCreateServiceDocuments,
      this.categoryInviteDeleteServiceRead,
      this.categoryInviteDeleteServiceWrite,
      this.categoryInviteDeleteServiceDocuments,
      this.categoryListRequestServiceRead,
      this.categoryListRequestServiceWrite,
      this.categoryListRequestServiceDocuments,
      this.userCategoryListRequestServiceRead,
      this.userCategoryListRequestServiceWrite,
      this.userCategoryListRequestServiceDocuments,
      this.categoryRootListRequestServiceRead,
      this.categoryRootListRequestServiceWrite,
      this.categoryRootListRequestServiceDocuments,
      this.categoryRequestServiceRead,
      this.categoryRequestServiceWrite,
      this.categoryRequestServiceDocuments,
      this.categoryInviteManagerServiceRead,
      this.categoryInviteManagerServiceWrite,
      this.categoryInviteManagerServiceDocuments,
      this.categoryInviteWorkerServiceRead,
      this.categoryInviteWorkerServiceWrite,
      this.categoryInviteWorkerServiceDocuments,
      this.categoryDeleteManagerServiceRead,
      this.categoryDeleteManagerServiceWrite,
      this.categoryDeleteManagerServiceDocuments,
      this.categoryDeleteWorkerServiceRead,
      this.categoryDeleteWorkerServiceWrite,
      this.categoryDeleteWorkerServiceDocuments,
      this.categoryUpdateServiceRead,
      this.categoryUpdateServiceWrite,
      this.categoryUpdateServiceDocuments,
      this.categoryCreateServiceRead,
      this.categoryCreateServiceWrite,
      this.categoryCreateServiceDocuments,
      this.categoryDeleteServiceRead,
      this.categoryDeleteServiceWrite,
      this.categoryDeleteServiceDocuments,
      this.categoryTreeCreateIfNotExistsServiceRead,
      this.categoryTreeCreateIfNotExistsServiceWrite,
      this.categoryTreeCreateIfNotExistsServiceDocuments,
      this.categoryTreeRequestServiceRead,
      this.categoryTreeRequestServiceWrite,
      this.categoryTreeRequestServiceDocuments,
      this.categoryTreeAddServiceRead,
      this.categoryTreeAddServiceWrite,
      this.categoryTreeAddServiceDocuments,
      this.categoryTreeDeleteServiceRead,
      this.categoryTreeDeleteServiceWrite,
      this.categoryTreeDeleteServiceDocuments,
      this.categoryTreeUpdateServiceRead,
      this.categoryTreeUpdateServiceWrite,
      this.categoryTreeUpdateServiceDocuments,
      this.uploadToFirebaseStorageMobileRead,
      this.uploadToFirebaseStorageMobileWrite,
      this.uploadToFirebaseStorageMobileDocuments,
      this.uploadToFirebaseStorageWebRead,
      this.uploadToFirebaseStorageWebWrite,
      this.uploadToFirebaseStorageWebDocuments,
      this.orderListRequestServiceRead,
      this.orderListRequestServiceWrite,
      this.orderListRequestServiceDocuments,
      this.orderRequestServiceRead,
      this.orderRequestServiceWrite,
      this.orderRequestServiceDocuments,
      this.orderUpdateServiceRead,
      this.orderUpdateServiceWrite,
      this.orderUpdateServiceDocuments,
      this.orderCreateServiceRead,
      this.orderCreateServiceWrite,
      this.orderCreateServiceDocuments,
      this.orderDeleteServiceRead,
      this.orderDeleteServiceWrite,
      this.orderDeleteServiceDocuments,
      this.pipelineListRequestServiceRead,
      this.pipelineListRequestServiceWrite,
      this.pipelineListRequestServiceDocuments,
      this.pipelineCreateServiceRead,
      this.pipelineCreateServiceWrite,
      this.pipelineCreateServiceDocuments,
      this.pipelineRequestServiceRead,
      this.pipelineRequestServiceWrite,
      this.pipelineRequestServiceDocuments,
      this.pipelineUpdateServiceRead,
      this.pipelineUpdateServiceWrite,
      this.pipelineUpdateServiceDocuments,
      this.serviceListRequestServiceRead,
      this.serviceListRequestServiceWrite,
      this.serviceListRequestServiceDocuments,
      this.serviceListAndNavigateRequestServiceRead,
      this.serviceListAndNavigateRequestServiceWrite,
      this.serviceListAndNavigateRequestServiceDocuments,
      this.serviceListAndNavigateOnConfirmRequestServiceRead,
      this.serviceListAndNavigateOnConfirmRequestServiceWrite,
      this.serviceListAndNavigateOnConfirmRequestServiceDocuments,
      this.serviceUpdateServiceRead,
      this.serviceUpdateServiceWrite,
      this.serviceUpdateServiceDocuments,
      this.serviceUpdateServiceVisibilityRead,
      this.serviceUpdateServiceVisibilityWrite,
      this.serviceUpdateServiceVisibilityDocuments,
      this.serviceCreateServiceRead,
      this.serviceCreateServiceWrite,
      this.serviceCreateServiceDocuments,
      this.stripePaymentAddPaymentMethodRead,
      this.stripePaymentAddPaymentMethodWrite,
      this.stripePaymentAddPaymentMethodDocuments,
      this.stripePaymentCardListRequestRead,
      this.stripePaymentCardListRequestWrite,
      this.stripePaymentCardListRequestDocuments,
      this.stripeDetachPaymentMethodRequestRead,
      this.stripeDetachPaymentMethodRequestWrite,
      this.stripeDetachPaymentMethodRequestDocuments,
      this.userRequestServiceRead,
      this.userRequestServiceWrite,
      this.userRequestServiceDocuments,
      this.userEditDeviceRead,
      this.userEditDeviceWrite,
      this.userEditDeviceDocuments,
      this.userEditTokenRead,
      this.userEditTokenWrite,
      this.userEditTokenDocuments
  });

  StatisticsState toEmpty() {
    return StatisticsState(
      bookingCreateRequestServiceRead: 0,
      bookingCreateRequestServiceWrite: 0,
      bookingCreateRequestServiceDocuments: 0,
      bookingRequestServiceRead: 0,
      bookingRequestServiceWrite: 0,
      bookingRequestServiceDocuments: 0,
      userBookingListRequestServiceRead: 0,
      userBookingListRequestServiceWrite: 0,
      userBookingListRequestServiceDocuments: 0,
      bookingListRequestServiceRead: 0,
      bookingListRequestServiceWrite: 0,
      bookingListRequestServiceDocuments: 0,
      bookingUpdateRequestServiceRead: 0,
      bookingUpdateRequestServiceWrite: 0,
      bookingUpdateRequestServiceDocuments: 0,
      bookingUpdateAndNavigateRequestServiceRead: 0,
      bookingUpdateAndNavigateRequestServiceWrite: 0,
      bookingUpdateAndNavigateRequestServiceDocuments: 0,
      businessListRequestServiceRead: 0,
      businessListRequestServiceWrite: 0,
      businessListRequestServiceDocuments: 0,
      businessAndNavigateRequestServiceRead: 0,
      businessAndNavigateRequestServiceWrite: 0,
      businessAndNavigateRequestServiceDocuments: 0,
      businessAndNavigateOnConfirmRequestServiceRead: 0,
      businessAndNavigateOnConfirmRequestServiceWrite: 0,
      businessAndNavigateOnConfirmRequestServiceDocuments: 0,
      businessRequestServiceRead: 0,
      businessRequestServiceWrite: 0,
      businessRequestServiceDocuments: 0,
      businessUpdateServiceRead: 0,
      businessUpdateServiceWrite: 0,
      businessUpdateServiceDocuments: 0,
      businessCreateServiceRead: 0,
      businessCreateServiceWrite: 0,
      businessCreateServiceDocuments: 0,
      categoryInviteRequestServiceRead: 0,
      categoryInviteRequestServiceWrite: 0,
      categoryInviteRequestServiceDocuments: 0,
      categoryInviteCreateServiceRead: 0,
      categoryInviteCreateServiceWrite: 0,
      categoryInviteCreateServiceDocuments: 0,
      categoryInviteDeleteServiceRead: 0,
      categoryInviteDeleteServiceWrite: 0,
      categoryInviteDeleteServiceDocuments: 0,
      categoryListRequestServiceRead: 0,
      categoryListRequestServiceWrite: 0,
      categoryListRequestServiceDocuments: 0,
      userCategoryListRequestServiceRead: 0,
      userCategoryListRequestServiceWrite: 0,
      userCategoryListRequestServiceDocuments: 0,
      categoryRootListRequestServiceRead: 0,
      categoryRootListRequestServiceWrite: 0,
      categoryRootListRequestServiceDocuments: 0,
      categoryRequestServiceRead: 0,
      categoryRequestServiceWrite: 0,
      categoryRequestServiceDocuments: 0,
      categoryInviteManagerServiceRead: 0,
      categoryInviteManagerServiceWrite: 0,
      categoryInviteManagerServiceDocuments: 0,
      categoryInviteWorkerServiceRead: 0,
      categoryInviteWorkerServiceWrite: 0,
      categoryInviteWorkerServiceDocuments: 0,
      categoryDeleteManagerServiceRead: 0,
      categoryDeleteManagerServiceWrite: 0,
      categoryDeleteManagerServiceDocuments: 0,
      categoryDeleteWorkerServiceRead: 0,
      categoryDeleteWorkerServiceWrite: 0,
      categoryDeleteWorkerServiceDocuments: 0,
      categoryUpdateServiceRead: 0,
      categoryUpdateServiceWrite: 0,
      categoryUpdateServiceDocuments: 0,
      categoryCreateServiceRead: 0,
      categoryCreateServiceWrite: 0,
      categoryCreateServiceDocuments: 0,
      categoryDeleteServiceRead: 0,
      categoryDeleteServiceWrite: 0,
      categoryDeleteServiceDocuments: 0,
      categoryTreeCreateIfNotExistsServiceRead: 0,
      categoryTreeCreateIfNotExistsServiceWrite: 0,
      categoryTreeCreateIfNotExistsServiceDocuments: 0,
      categoryTreeRequestServiceRead: 0,
      categoryTreeRequestServiceWrite: 0,
      categoryTreeRequestServiceDocuments: 0,
      categoryTreeAddServiceRead: 0,
      categoryTreeAddServiceWrite: 0,
      categoryTreeAddServiceDocuments: 0,
      categoryTreeDeleteServiceRead: 0,
      categoryTreeDeleteServiceWrite: 0,
      categoryTreeDeleteServiceDocuments: 0,
      categoryTreeUpdateServiceRead: 0,
      categoryTreeUpdateServiceWrite: 0,
      categoryTreeUpdateServiceDocuments: 0,
      uploadToFirebaseStorageMobileRead: 0,
      uploadToFirebaseStorageMobileWrite: 0,
      uploadToFirebaseStorageMobileDocuments: 0,
      uploadToFirebaseStorageWebRead: 0,
      uploadToFirebaseStorageWebWrite: 0,
      uploadToFirebaseStorageWebDocuments: 0,
      orderListRequestServiceRead: 0,
      orderListRequestServiceWrite: 0,
      orderListRequestServiceDocuments: 0,
      orderRequestServiceRead: 0,
      orderRequestServiceWrite: 0,
      orderRequestServiceDocuments: 0,
      orderUpdateServiceRead: 0,
      orderUpdateServiceWrite: 0,
      orderUpdateServiceDocuments: 0,
      orderCreateServiceRead: 0,
      orderCreateServiceWrite: 0,
      orderCreateServiceDocuments: 0,
      orderDeleteServiceRead: 0,
      orderDeleteServiceWrite: 0,
      orderDeleteServiceDocuments: 0,
      pipelineListRequestServiceRead: 0,
      pipelineListRequestServiceWrite: 0,
      pipelineListRequestServiceDocuments: 0,
      pipelineCreateServiceRead: 0,
      pipelineCreateServiceWrite: 0,
      pipelineCreateServiceDocuments: 0,
      pipelineRequestServiceRead: 0,
      pipelineRequestServiceWrite: 0,
      pipelineRequestServiceDocuments: 0,
      pipelineUpdateServiceRead: 0,
      pipelineUpdateServiceWrite: 0,
      pipelineUpdateServiceDocuments: 0,
      serviceListRequestServiceRead: 0,
      serviceListRequestServiceWrite: 0,
      serviceListRequestServiceDocuments: 0,
      serviceListAndNavigateRequestServiceRead: 0,
      serviceListAndNavigateRequestServiceWrite: 0,
      serviceListAndNavigateRequestServiceDocuments: 0,
      serviceListAndNavigateOnConfirmRequestServiceRead: 0,
      serviceListAndNavigateOnConfirmRequestServiceWrite: 0,
      serviceListAndNavigateOnConfirmRequestServiceDocuments: 0,
      serviceUpdateServiceRead: 0,
      serviceUpdateServiceWrite: 0,
      serviceUpdateServiceDocuments: 0,
      serviceUpdateServiceVisibilityRead: 0,
      serviceUpdateServiceVisibilityWrite: 0,
      serviceUpdateServiceVisibilityDocuments: 0,
      serviceCreateServiceRead: 0,
      serviceCreateServiceWrite: 0,
      serviceCreateServiceDocuments: 0,
      stripePaymentAddPaymentMethodRead: 0,
      stripePaymentAddPaymentMethodWrite: 0,
      stripePaymentAddPaymentMethodDocuments: 0,
      stripePaymentCardListRequestRead: 0,
      stripePaymentCardListRequestWrite: 0,
      stripePaymentCardListRequestDocuments: 0,
      stripeDetachPaymentMethodRequestRead: 0,
      stripeDetachPaymentMethodRequestWrite: 0,
      stripeDetachPaymentMethodRequestDocuments: 0,
      userRequestServiceRead: 0,
      userRequestServiceWrite: 0,
      userRequestServiceDocuments: 0,
      userEditDeviceRead: 0,
      userEditDeviceWrite: 0,
      userEditDeviceDocuments: 0,
      userEditTokenRead: 0,
      userEditTokenWrite: 0,
      userEditTokenDocuments: 0,
    );
  }

  StatisticsState.fromState(StatisticsState state) {
    this.bookingCreateRequestServiceRead = state.bookingCreateRequestServiceRead;
    this.bookingCreateRequestServiceWrite = state.bookingCreateRequestServiceWrite;
    this.bookingCreateRequestServiceDocuments= state.bookingCreateRequestServiceDocuments;
    this.bookingRequestServiceRead= state.bookingRequestServiceRead;
    this.bookingRequestServiceWrite = state.bookingRequestServiceWrite;
    this.bookingRequestServiceDocuments = state.bookingRequestServiceDocuments;
    this.userBookingListRequestServiceRead = state.userBookingListRequestServiceRead;
    this.userBookingListRequestServiceWrite = state.userBookingListRequestServiceWrite;
    this.userBookingListRequestServiceDocuments = state.userBookingListRequestServiceDocuments;
    this.bookingListRequestServiceRead = state.bookingListRequestServiceRead;
    this.bookingListRequestServiceWrite = state.bookingListRequestServiceWrite;
    this.bookingListRequestServiceDocuments = state.bookingListRequestServiceDocuments;
    this.bookingUpdateRequestServiceRead = state.bookingUpdateRequestServiceRead;
    this.bookingUpdateRequestServiceWrite = state.bookingUpdateRequestServiceWrite;
    this.bookingUpdateRequestServiceDocuments = state.bookingUpdateRequestServiceDocuments;
    this.bookingUpdateAndNavigateRequestServiceRead = state.bookingUpdateAndNavigateRequestServiceRead;
    this.bookingUpdateAndNavigateRequestServiceWrite = state.bookingUpdateAndNavigateRequestServiceWrite;
    this.bookingUpdateAndNavigateRequestServiceDocuments = state.bookingUpdateAndNavigateRequestServiceDocuments;
    this.businessListRequestServiceRead = state.businessListRequestServiceRead;
    this.businessListRequestServiceWrite = state.businessListRequestServiceWrite;
    this.businessListRequestServiceDocuments = state.businessListRequestServiceDocuments;
    this.businessAndNavigateRequestServiceRead = state.businessAndNavigateRequestServiceRead;
    this.businessAndNavigateRequestServiceWrite = state.businessAndNavigateRequestServiceWrite;
    this.businessAndNavigateRequestServiceDocuments = state.businessAndNavigateRequestServiceDocuments;
    this.businessAndNavigateOnConfirmRequestServiceRead = state.businessAndNavigateOnConfirmRequestServiceRead;
    this.businessAndNavigateOnConfirmRequestServiceWrite = state.businessAndNavigateOnConfirmRequestServiceWrite;
    this.businessAndNavigateOnConfirmRequestServiceDocuments = state.businessAndNavigateOnConfirmRequestServiceDocuments;
    this.businessRequestServiceRead = state.businessRequestServiceRead;
    this.businessRequestServiceWrite = state.businessRequestServiceWrite;
    this.businessRequestServiceDocuments = state.businessRequestServiceDocuments;
    this.businessUpdateServiceRead = state.businessUpdateServiceRead;
    this.businessUpdateServiceWrite = state.businessUpdateServiceWrite;
    this.businessUpdateServiceDocuments = state.businessUpdateServiceDocuments;
    this.businessCreateServiceRead = state.businessCreateServiceRead;
    this.businessCreateServiceWrite = state.businessCreateServiceWrite;
    this.businessCreateServiceDocuments = state.businessCreateServiceDocuments;
    this.categoryInviteRequestServiceRead = state.categoryInviteRequestServiceRead;
    this.categoryInviteRequestServiceWrite = state.categoryInviteRequestServiceWrite;
    this.categoryInviteRequestServiceDocuments = state.categoryInviteRequestServiceDocuments;
    this.categoryInviteCreateServiceRead = state.categoryInviteCreateServiceRead;
    this.categoryInviteCreateServiceWrite = state.categoryInviteCreateServiceWrite;
    this.categoryInviteCreateServiceDocuments = state.categoryInviteCreateServiceDocuments;
    this.categoryInviteDeleteServiceRead = state.categoryInviteDeleteServiceRead;
    this.categoryInviteDeleteServiceWrite = state.categoryInviteDeleteServiceWrite;
    this.categoryInviteDeleteServiceDocuments = state.categoryInviteDeleteServiceDocuments;
    this.categoryListRequestServiceRead = state.categoryListRequestServiceRead;
    this.categoryListRequestServiceWrite = state.categoryListRequestServiceWrite;
    this.categoryListRequestServiceDocuments = state.categoryListRequestServiceDocuments;
    this.userCategoryListRequestServiceRead = state.userCategoryListRequestServiceRead;
    this.userCategoryListRequestServiceWrite = state.userCategoryListRequestServiceWrite;
    this.userCategoryListRequestServiceDocuments = state.userCategoryListRequestServiceDocuments;
    this.categoryRootListRequestServiceRead = state.categoryRootListRequestServiceRead;
    this.categoryRootListRequestServiceWrite = state.categoryRootListRequestServiceWrite;
    this.categoryRootListRequestServiceDocuments = state.categoryRootListRequestServiceDocuments;
    this.categoryRequestServiceRead = state.categoryRequestServiceRead;
    this.categoryRequestServiceWrite = state.categoryRequestServiceWrite;
    this.categoryRequestServiceDocuments = state.categoryRequestServiceDocuments;
    this.categoryInviteManagerServiceRead = state.categoryInviteManagerServiceRead;
    this.categoryInviteManagerServiceWrite = state.categoryInviteManagerServiceWrite;
    this.categoryInviteManagerServiceDocuments = state.categoryInviteManagerServiceDocuments;
    this.categoryInviteWorkerServiceRead = state.categoryInviteWorkerServiceRead;
    this.categoryInviteWorkerServiceWrite = state.categoryInviteWorkerServiceWrite;
    this.categoryInviteWorkerServiceDocuments = state.categoryInviteWorkerServiceDocuments;
    this.categoryDeleteManagerServiceRead = state.categoryDeleteManagerServiceRead;
    this.categoryDeleteManagerServiceWrite = state.categoryDeleteManagerServiceWrite;
    this.categoryDeleteManagerServiceDocuments = state.categoryDeleteManagerServiceDocuments;
    this.categoryDeleteWorkerServiceRead = state.categoryDeleteWorkerServiceRead;
    this.categoryDeleteWorkerServiceWrite = state.categoryDeleteWorkerServiceWrite;
    this.categoryDeleteWorkerServiceDocuments = state.categoryDeleteWorkerServiceDocuments;
    this.categoryUpdateServiceRead = state.categoryUpdateServiceRead;
    this.categoryUpdateServiceWrite = state.categoryUpdateServiceWrite;
    this.categoryUpdateServiceDocuments = state.categoryUpdateServiceDocuments;
    this.categoryCreateServiceRead = state.categoryCreateServiceRead;
    this.categoryCreateServiceWrite = state.categoryCreateServiceWrite;
    this.categoryCreateServiceDocuments = state.categoryCreateServiceDocuments;
    this.categoryDeleteServiceRead = state.categoryDeleteServiceRead;
    this.categoryDeleteServiceWrite = state.categoryDeleteServiceWrite;
    this.categoryDeleteServiceDocuments = state.categoryDeleteServiceDocuments;
    this.categoryTreeCreateIfNotExistsServiceRead = state.categoryTreeCreateIfNotExistsServiceRead;
    this.categoryTreeCreateIfNotExistsServiceWrite = state.categoryTreeCreateIfNotExistsServiceWrite;
    this.categoryTreeCreateIfNotExistsServiceDocuments = state.categoryTreeCreateIfNotExistsServiceDocuments;
    this.categoryTreeRequestServiceRead = state.categoryTreeRequestServiceRead;
    this.categoryTreeRequestServiceWrite = state.categoryTreeRequestServiceWrite;
    this.categoryTreeRequestServiceDocuments = state.categoryTreeRequestServiceDocuments;
    this.categoryTreeAddServiceRead = state.categoryTreeAddServiceRead;
    this.categoryTreeAddServiceWrite = state.categoryTreeAddServiceWrite;
    this.categoryTreeAddServiceDocuments = state.categoryTreeAddServiceDocuments;
    this.categoryTreeDeleteServiceRead = state.categoryTreeDeleteServiceRead;
    this.categoryTreeDeleteServiceWrite = state.categoryTreeDeleteServiceWrite;
    this.categoryTreeDeleteServiceDocuments = state.categoryTreeDeleteServiceDocuments;
    this.categoryTreeUpdateServiceRead = state.categoryTreeUpdateServiceRead;
    this.categoryTreeUpdateServiceWrite  = state.categoryTreeUpdateServiceWrite;
    this.categoryTreeUpdateServiceDocuments = state.categoryTreeUpdateServiceDocuments;
    this.uploadToFirebaseStorageMobileRead = state.uploadToFirebaseStorageMobileRead;
    this.uploadToFirebaseStorageMobileWrite = state.uploadToFirebaseStorageMobileWrite;
    this.uploadToFirebaseStorageMobileDocuments = state.uploadToFirebaseStorageMobileDocuments;
    this.uploadToFirebaseStorageWebRead = state.uploadToFirebaseStorageWebRead;
    this.uploadToFirebaseStorageWebWrite = state.uploadToFirebaseStorageWebWrite;
    this.uploadToFirebaseStorageWebDocuments = state.uploadToFirebaseStorageWebDocuments;
    this.orderListRequestServiceRead = state.orderListRequestServiceRead;
    this.orderListRequestServiceWrite = state.orderListRequestServiceWrite;
    this.orderListRequestServiceDocuments = state.orderListRequestServiceDocuments;
    this.orderRequestServiceRead = state.orderRequestServiceRead;
    this.orderRequestServiceWrite = state.orderRequestServiceWrite;
    this.orderRequestServiceDocuments = state.orderRequestServiceDocuments;
    this.orderUpdateServiceRead = state.orderUpdateServiceRead;
    this.orderUpdateServiceWrite = state.orderUpdateServiceWrite;
    this.orderUpdateServiceDocuments = state.orderUpdateServiceDocuments;
    this.orderCreateServiceRead = state.orderCreateServiceRead;
    this.orderCreateServiceWrite = state.orderCreateServiceWrite;
    this.orderCreateServiceDocuments = state.orderCreateServiceDocuments;
    this.orderDeleteServiceRead = state.orderDeleteServiceRead;
    this.orderDeleteServiceWrite = state.orderDeleteServiceWrite;
    this.orderDeleteServiceDocuments = state.orderDeleteServiceDocuments;
    this.pipelineListRequestServiceRead = state.pipelineListRequestServiceRead;
    this.pipelineListRequestServiceWrite = state.pipelineListRequestServiceWrite;
    this.pipelineListRequestServiceDocuments = state.pipelineListRequestServiceDocuments;
    this.pipelineCreateServiceRead = state.pipelineCreateServiceRead;
    this.pipelineCreateServiceWrite = state.pipelineCreateServiceWrite;
    this.pipelineCreateServiceDocuments = state.pipelineCreateServiceDocuments;
    this.pipelineRequestServiceRead = state.pipelineRequestServiceRead;
    this.pipelineRequestServiceWrite = state.pipelineRequestServiceWrite;
    this.pipelineRequestServiceDocuments = state.pipelineRequestServiceDocuments;
    this.pipelineUpdateServiceRead = state.pipelineUpdateServiceRead;
    this.pipelineUpdateServiceWrite = state.pipelineUpdateServiceWrite;
    this.pipelineUpdateServiceDocuments = state.pipelineUpdateServiceDocuments;
    this.serviceListRequestServiceRead = state.serviceListRequestServiceRead;
    this.serviceListRequestServiceWrite = state.serviceListRequestServiceWrite;
    this.serviceListRequestServiceDocuments = state.serviceListRequestServiceDocuments;
    this.serviceListAndNavigateRequestServiceRead = state.serviceListAndNavigateRequestServiceRead;
    this.serviceListAndNavigateRequestServiceWrite = state.serviceListAndNavigateRequestServiceWrite;
    this.serviceListAndNavigateRequestServiceDocuments = state.serviceListAndNavigateRequestServiceDocuments;
    this.serviceListAndNavigateOnConfirmRequestServiceRead = state.serviceListAndNavigateOnConfirmRequestServiceRead;
    this.serviceListAndNavigateOnConfirmRequestServiceWrite = state.serviceListAndNavigateOnConfirmRequestServiceWrite;
    this.serviceListAndNavigateOnConfirmRequestServiceDocuments = state.serviceListAndNavigateOnConfirmRequestServiceDocuments;
    this.serviceUpdateServiceRead = state.serviceUpdateServiceRead;
    this.serviceUpdateServiceWrite = state.serviceUpdateServiceWrite;
    this.serviceUpdateServiceDocuments = state.serviceUpdateServiceDocuments;
    this.serviceUpdateServiceVisibilityRead = state.serviceUpdateServiceVisibilityRead;
    this.serviceUpdateServiceVisibilityWrite = state.serviceUpdateServiceVisibilityWrite;
    this.serviceUpdateServiceVisibilityDocuments = state.serviceUpdateServiceVisibilityDocuments;
    this.serviceCreateServiceRead = state.serviceCreateServiceRead;
    this.serviceCreateServiceWrite = state.serviceCreateServiceWrite;
    this.serviceCreateServiceDocuments = state.serviceCreateServiceDocuments;
    this.stripePaymentAddPaymentMethodRead = state.stripePaymentAddPaymentMethodRead;
    this.stripePaymentAddPaymentMethodWrite = state.stripePaymentAddPaymentMethodWrite;
    this.stripePaymentAddPaymentMethodDocuments = state.stripePaymentAddPaymentMethodDocuments;
    this.stripePaymentCardListRequestRead = state.stripePaymentCardListRequestRead;
    this.stripePaymentCardListRequestWrite = state.stripePaymentCardListRequestWrite;
    this.stripePaymentCardListRequestDocuments = state.stripePaymentCardListRequestDocuments;
    this.stripeDetachPaymentMethodRequestRead = state.stripeDetachPaymentMethodRequestRead;
    this.stripeDetachPaymentMethodRequestWrite = state.stripeDetachPaymentMethodRequestWrite;
    this.stripeDetachPaymentMethodRequestDocuments = state.stripeDetachPaymentMethodRequestDocuments;
    this.userRequestServiceRead = state.userRequestServiceRead;
    this.userRequestServiceWrite = state.userRequestServiceWrite;
    this.userRequestServiceDocuments = state.userRequestServiceDocuments;
    this.userEditDeviceRead = state.userEditDeviceRead;
    this.userEditDeviceWrite = state.userEditDeviceWrite;
    this.userEditDeviceDocuments = state.userEditDeviceDocuments;
    this.userEditTokenRead = state.userEditTokenRead;
    this.userEditTokenWrite = state.userEditTokenWrite;
    this.userEditTokenDocuments = state.userEditTokenDocuments;
  }

  StatisticsState copyWith({
    int bookingCreateRequestServiceRead,
    int bookingCreateRequestServiceWrite,
    int bookingCreateRequestServiceDocuments,
    int bookingRequestServiceRead,
    int bookingRequestServiceWrite,
    int bookingRequestServiceDocuments,
    int userBookingListRequestServiceRead,
    int userBookingListRequestServiceWrite,
    int userBookingListRequestServiceDocuments,
    int bookingListRequestServiceRead,
    int bookingListRequestServiceWrite,
    int bookingListRequestServiceDocuments,
    int bookingUpdateRequestServiceRead,
    int bookingUpdateRequestServiceWrite,
    int bookingUpdateRequestServiceDocuments,
    int bookingUpdateAndNavigateRequestServiceRead,
    int bookingUpdateAndNavigateRequestServiceWrite,
    int bookingUpdateAndNavigateRequestServiceDocuments,
    int businessListRequestServiceRead,
    int businessListRequestServiceWrite,
    int businessListRequestServiceDocuments,
    int businessAndNavigateRequestServiceRead,
    int businessAndNavigateRequestServiceWrite,
    int businessAndNavigateRequestServiceDocuments,
    int businessAndNavigateOnConfirmRequestServiceRead,
    int businessAndNavigateOnConfirmRequestServiceWrite,
    int businessAndNavigateOnConfirmRequestServiceDocuments,
    int businessRequestServiceRead,
    int businessRequestServiceWrite,
    int businessRequestServiceDocuments,
    int businessUpdateServiceRead,
    int businessUpdateServiceWrite,
    int businessUpdateServiceDocuments,
    int businessCreateServiceRead,
    int businessCreateServiceWrite,
    int businessCreateServiceDocuments,
    int categoryInviteRequestServiceRead,
    int categoryInviteRequestServiceWrite,
    int categoryInviteRequestServiceDocuments,
    int categoryInviteCreateServiceRead,
    int categoryInviteCreateServiceWrite,
    int categoryInviteCreateServiceDocuments,
    int categoryInviteDeleteServiceRead,
    int categoryInviteDeleteServiceWrite,
    int categoryInviteDeleteServiceDocuments,
    int categoryListRequestServiceRead,
    int categoryListRequestServiceWrite,
    int categoryListRequestServiceDocuments,
    int userCategoryListRequestServiceRead,
    int userCategoryListRequestServiceWrite,
    int userCategoryListRequestServiceDocuments,
    int categoryRootListRequestServiceRead,
    int categoryRootListRequestServiceWrite,
    int categoryRootListRequestServiceDocuments,
    int categoryRequestServiceRead,
    int categoryRequestServiceWrite,
    int categoryRequestServiceDocuments,
    int categoryInviteManagerServiceRead,
    int categoryInviteManagerServiceWrite,
    int categoryInviteManagerServiceDocuments,
    int categoryInviteWorkerServiceRead,
    int categoryInviteWorkerServiceWrite,
    int categoryInviteWorkerServiceDocuments,
    int categoryDeleteManagerServiceRead,
    int categoryDeleteManagerServiceWrite,
    int categoryDeleteManagerServiceDocuments,
    int categoryDeleteWorkerServiceRead,
    int categoryDeleteWorkerServiceWrite,
    int categoryDeleteWorkerServiceDocuments,
    int categoryUpdateServiceRead,
    int categoryUpdateServiceWrite,
    int categoryUpdateServiceDocuments,
    int categoryCreateServiceRead,
    int categoryCreateServiceWrite,
    int categoryCreateServiceDocuments,
    int categoryDeleteServiceRead,
    int categoryDeleteServiceWrite,
    int categoryDeleteServiceDocuments,
    int categoryTreeCreateIfNotExistsServiceRead,
    int categoryTreeCreateIfNotExistsServiceWrite,
    int categoryTreeCreateIfNotExistsServiceDocuments,
    int categoryTreeRequestServiceRead,
    int categoryTreeRequestServiceWrite,
    int categoryTreeRequestServiceDocuments,
    int categoryTreeAddServiceRead,
    int categoryTreeAddServiceWrite,
    int categoryTreeAddServiceDocuments,
    int categoryTreeDeleteServiceRead,
    int categoryTreeDeleteServiceWrite,
    int categoryTreeDeleteServiceDocuments,
    int categoryTreeUpdateServiceRead,
    int categoryTreeUpdateServiceWrite,
    int categoryTreeUpdateServiceDocuments,
    int uploadToFirebaseStorageMobileRead,
    int uploadToFirebaseStorageMobileWrite,
    int uploadToFirebaseStorageMobileDocuments,
    int uploadToFirebaseStorageWebRead,
    int uploadToFirebaseStorageWebWrite,
    int uploadToFirebaseStorageWebDocuments,
    int orderListRequestServiceRead,
    int orderListRequestServiceWrite,
    int orderListRequestServiceDocuments,
    int orderRequestServiceRead,
    int orderRequestServiceWrite,
    int orderRequestServiceDocuments,
    int orderUpdateServiceRead,
    int orderUpdateServiceWrite,
    int orderUpdateServiceDocuments,
    int orderCreateServiceRead,
    int orderCreateServiceWrite,
    int orderCreateServiceDocuments,
    int orderDeleteServiceRead,
    int orderDeleteServiceWrite,
    int orderDeleteServiceDocuments,
    int pipelineListRequestServiceRead,
    int pipelineListRequestServiceWrite,
    int pipelineListRequestServiceDocuments,
    int pipelineCreateServiceRead,
    int pipelineCreateServiceWrite,
    int pipelineCreateServiceDocuments,
    int pipelineRequestServiceRead,
    int pipelineRequestServiceWrite,
    int pipelineRequestServiceDocuments,
    int pipelineUpdateServiceRead,
    int pipelineUpdateServiceWrite,
    int pipelineUpdateServiceDocuments,
    int serviceListRequestServiceRead,
    int serviceListRequestServiceWrite,
    int serviceListRequestServiceDocuments,
    int serviceListAndNavigateRequestServiceRead,
    int serviceListAndNavigateRequestServiceWrite,
    int serviceListAndNavigateRequestServiceDocuments,
    int serviceListAndNavigateOnConfirmRequestServiceRead,
    int serviceListAndNavigateOnConfirmRequestServiceWrite,
    int serviceListAndNavigateOnConfirmRequestServiceDocuments,
    int serviceUpdateServiceRead,
    int serviceUpdateServiceWrite,
    int serviceUpdateServiceDocuments,
    int serviceUpdateServiceVisibilityRead,
    int serviceUpdateServiceVisibilityWrite,
    int serviceUpdateServiceVisibilityDocuments,
    int serviceCreateServiceRead,
    int serviceCreateServiceWrite,
    int serviceCreateServiceDocuments,
    int stripePaymentAddPaymentMethodRead,
    int stripePaymentAddPaymentMethodWrite,
    int stripePaymentAddPaymentMethodDocuments,
    int stripePaymentCardListRequestRead,
    int stripePaymentCardListRequestWrite,
    int stripePaymentCardListRequestDocuments,
    int stripeDetachPaymentMethodRequestRead,
    int stripeDetachPaymentMethodRequestWrite,
    int stripeDetachPaymentMethodRequestDocuments,
    int userRequestServiceRead,
    int userRequestServiceWrite,
    int userRequestServiceDocuments,
    int userEditDeviceRead,
    int userEditDeviceWrite,
    int userEditDeviceDocuments,
    int userEditTokenRead,
    int userEditTokenWrite,
    int userEditTokenDocuments
  }) {
    return StatisticsState(
      bookingCreateRequestServiceRead: bookingCreateRequestServiceRead ?? this.bookingCreateRequestServiceRead,
      bookingCreateRequestServiceWrite: bookingCreateRequestServiceWrite ?? this.bookingCreateRequestServiceWrite,
      bookingCreateRequestServiceDocuments: bookingCreateRequestServiceDocuments ?? this.bookingCreateRequestServiceDocuments,
      bookingRequestServiceRead: bookingRequestServiceRead ?? this.bookingRequestServiceRead,
      bookingRequestServiceWrite: bookingRequestServiceWrite ?? this.bookingRequestServiceWrite,
      bookingRequestServiceDocuments: bookingRequestServiceDocuments ?? this.bookingRequestServiceDocuments,
      userBookingListRequestServiceRead: userBookingListRequestServiceRead ?? this.userBookingListRequestServiceRead,
      userBookingListRequestServiceWrite: userBookingListRequestServiceWrite ?? this.userBookingListRequestServiceWrite,
      userBookingListRequestServiceDocuments: userBookingListRequestServiceDocuments ?? this.userBookingListRequestServiceDocuments,
      bookingListRequestServiceRead: bookingListRequestServiceRead ?? this.bookingListRequestServiceRead,
      bookingListRequestServiceWrite: bookingListRequestServiceWrite ?? this.bookingListRequestServiceWrite,
      bookingListRequestServiceDocuments: bookingListRequestServiceDocuments ?? this.bookingListRequestServiceDocuments,
      bookingUpdateRequestServiceRead: bookingUpdateRequestServiceRead ?? this.bookingUpdateRequestServiceRead,
      bookingUpdateRequestServiceWrite: bookingUpdateRequestServiceWrite ?? this.bookingUpdateRequestServiceWrite,
      bookingUpdateRequestServiceDocuments: bookingUpdateRequestServiceDocuments ?? this.bookingUpdateRequestServiceDocuments,
      bookingUpdateAndNavigateRequestServiceRead: bookingUpdateAndNavigateRequestServiceRead ?? this.bookingUpdateAndNavigateRequestServiceRead,
      bookingUpdateAndNavigateRequestServiceWrite: bookingUpdateAndNavigateRequestServiceWrite ?? this.bookingUpdateAndNavigateRequestServiceWrite,
      bookingUpdateAndNavigateRequestServiceDocuments: bookingUpdateAndNavigateRequestServiceDocuments ?? this.bookingUpdateAndNavigateRequestServiceDocuments,
      businessListRequestServiceRead: businessListRequestServiceRead ?? this.businessListRequestServiceRead,
      businessListRequestServiceWrite: businessListRequestServiceWrite ?? this.businessListRequestServiceWrite,
      businessListRequestServiceDocuments: businessListRequestServiceDocuments ?? this.businessListRequestServiceDocuments,
      businessAndNavigateRequestServiceRead: businessAndNavigateRequestServiceRead ?? this.businessAndNavigateRequestServiceRead,
      businessAndNavigateRequestServiceWrite: businessAndNavigateRequestServiceWrite ?? this.businessAndNavigateRequestServiceWrite,
      businessAndNavigateRequestServiceDocuments: businessAndNavigateRequestServiceDocuments ?? this.businessAndNavigateRequestServiceDocuments,
      businessAndNavigateOnConfirmRequestServiceRead: businessAndNavigateOnConfirmRequestServiceRead ?? this.businessAndNavigateOnConfirmRequestServiceRead,
      businessAndNavigateOnConfirmRequestServiceWrite: businessAndNavigateOnConfirmRequestServiceWrite ?? this.businessAndNavigateOnConfirmRequestServiceWrite,
      businessAndNavigateOnConfirmRequestServiceDocuments: businessAndNavigateOnConfirmRequestServiceDocuments ?? this.businessAndNavigateOnConfirmRequestServiceDocuments,
      businessRequestServiceRead: businessRequestServiceRead ?? this.businessRequestServiceRead,
      businessRequestServiceWrite: businessRequestServiceWrite ?? this.businessRequestServiceWrite,
      businessRequestServiceDocuments: businessRequestServiceDocuments ?? this.businessRequestServiceDocuments,
      businessUpdateServiceRead: businessUpdateServiceRead ?? this.businessUpdateServiceRead,
      businessUpdateServiceWrite: businessUpdateServiceWrite ?? this.businessUpdateServiceWrite,
      businessUpdateServiceDocuments: businessUpdateServiceDocuments ?? this.businessUpdateServiceDocuments,
      businessCreateServiceRead: businessCreateServiceRead ?? this.businessCreateServiceRead,
      businessCreateServiceWrite: businessCreateServiceWrite ?? this.businessCreateServiceWrite,
      businessCreateServiceDocuments: businessCreateServiceDocuments ?? this.businessCreateServiceDocuments,
      categoryInviteRequestServiceRead: categoryInviteRequestServiceRead ?? this.categoryInviteRequestServiceRead,
      categoryInviteRequestServiceWrite: categoryInviteRequestServiceWrite ?? this.categoryInviteRequestServiceWrite,
      categoryInviteRequestServiceDocuments: categoryInviteRequestServiceDocuments ?? this.categoryInviteRequestServiceDocuments,
      categoryInviteCreateServiceRead: categoryInviteCreateServiceRead ?? this.categoryInviteCreateServiceRead,
      categoryInviteCreateServiceWrite: categoryInviteCreateServiceWrite ?? this.categoryInviteCreateServiceWrite,
      categoryInviteCreateServiceDocuments: categoryInviteCreateServiceDocuments ?? this.categoryInviteCreateServiceDocuments,
      categoryInviteDeleteServiceRead: categoryInviteDeleteServiceRead ?? this.categoryInviteDeleteServiceRead,
      categoryInviteDeleteServiceWrite: categoryInviteDeleteServiceWrite ?? this.categoryInviteDeleteServiceWrite,
      categoryInviteDeleteServiceDocuments: categoryInviteDeleteServiceDocuments ?? this.categoryInviteDeleteServiceDocuments,
      categoryListRequestServiceRead: categoryListRequestServiceRead ?? this.categoryListRequestServiceRead,
      categoryListRequestServiceWrite: categoryListRequestServiceWrite ?? this.categoryListRequestServiceWrite,
      categoryListRequestServiceDocuments: categoryListRequestServiceDocuments ?? this.categoryListRequestServiceDocuments,
      userCategoryListRequestServiceRead: userCategoryListRequestServiceRead ?? this.userCategoryListRequestServiceRead,
      userCategoryListRequestServiceWrite: userCategoryListRequestServiceWrite ?? this.userCategoryListRequestServiceWrite,
      userCategoryListRequestServiceDocuments: userCategoryListRequestServiceDocuments ?? this.userCategoryListRequestServiceDocuments,
      categoryRootListRequestServiceRead: categoryRootListRequestServiceRead ?? this.categoryRootListRequestServiceRead,
      categoryRootListRequestServiceWrite: categoryRootListRequestServiceWrite ?? this.categoryRootListRequestServiceWrite,
      categoryRootListRequestServiceDocuments: categoryRootListRequestServiceDocuments ?? this.categoryRootListRequestServiceDocuments,
      categoryRequestServiceRead: categoryRequestServiceRead ?? this.categoryRequestServiceRead,
      categoryRequestServiceWrite: categoryRequestServiceWrite ?? this.categoryRequestServiceWrite,
      categoryRequestServiceDocuments: categoryRequestServiceDocuments ?? this.categoryRequestServiceDocuments,
      categoryInviteManagerServiceRead: categoryInviteManagerServiceRead ?? this.categoryInviteManagerServiceRead,
      categoryInviteManagerServiceWrite: categoryInviteManagerServiceWrite ?? this.categoryInviteManagerServiceWrite,
      categoryInviteManagerServiceDocuments: categoryInviteManagerServiceDocuments ?? this.categoryInviteManagerServiceDocuments,
      categoryInviteWorkerServiceRead: categoryInviteWorkerServiceRead ?? this.categoryInviteWorkerServiceRead,
      categoryInviteWorkerServiceWrite: categoryInviteWorkerServiceWrite ?? this.categoryInviteWorkerServiceWrite,
      categoryInviteWorkerServiceDocuments: categoryInviteWorkerServiceDocuments ?? this.categoryInviteWorkerServiceDocuments,
      categoryDeleteManagerServiceRead: categoryDeleteManagerServiceRead ?? this.categoryDeleteManagerServiceRead,
      categoryDeleteManagerServiceWrite: categoryDeleteManagerServiceWrite ?? this.categoryDeleteManagerServiceWrite,
      categoryDeleteManagerServiceDocuments: categoryDeleteManagerServiceDocuments ?? this.categoryDeleteManagerServiceDocuments,
      categoryDeleteWorkerServiceRead: categoryDeleteWorkerServiceRead ?? this.categoryDeleteWorkerServiceRead,
      categoryDeleteWorkerServiceWrite: categoryDeleteWorkerServiceWrite ?? this.categoryDeleteWorkerServiceWrite,
      categoryDeleteWorkerServiceDocuments: categoryDeleteWorkerServiceDocuments ?? this.categoryDeleteWorkerServiceDocuments,
      categoryUpdateServiceRead: categoryUpdateServiceRead ?? this.categoryUpdateServiceRead,
      categoryUpdateServiceWrite: categoryUpdateServiceWrite ?? this.categoryUpdateServiceWrite,
      categoryUpdateServiceDocuments: categoryUpdateServiceDocuments ?? this.categoryUpdateServiceDocuments,
      categoryCreateServiceRead: categoryCreateServiceRead ?? this.categoryCreateServiceRead,
      categoryCreateServiceWrite: categoryCreateServiceWrite ?? this.categoryCreateServiceWrite,
      categoryCreateServiceDocuments: categoryCreateServiceDocuments ?? this.categoryCreateServiceDocuments,
      categoryDeleteServiceRead: categoryDeleteServiceRead ?? this.categoryDeleteServiceRead,
      categoryDeleteServiceWrite: categoryDeleteServiceWrite ?? this.categoryDeleteServiceWrite,
      categoryDeleteServiceDocuments: categoryDeleteServiceDocuments ?? this.categoryDeleteServiceDocuments,
      categoryTreeCreateIfNotExistsServiceRead: categoryTreeCreateIfNotExistsServiceRead ?? this.categoryTreeCreateIfNotExistsServiceRead,
      categoryTreeCreateIfNotExistsServiceWrite: categoryTreeCreateIfNotExistsServiceWrite ?? this.categoryTreeCreateIfNotExistsServiceWrite,
      categoryTreeCreateIfNotExistsServiceDocuments: categoryTreeCreateIfNotExistsServiceDocuments ?? this.categoryTreeCreateIfNotExistsServiceDocuments,
      categoryTreeRequestServiceRead: categoryTreeRequestServiceRead ?? this.categoryTreeRequestServiceRead,
      categoryTreeRequestServiceWrite: categoryTreeRequestServiceWrite ?? this.categoryTreeRequestServiceWrite,
      categoryTreeRequestServiceDocuments: categoryTreeRequestServiceDocuments ?? this.categoryTreeRequestServiceDocuments,
      categoryTreeAddServiceRead: categoryTreeAddServiceRead ?? this.categoryTreeAddServiceRead,
      categoryTreeAddServiceWrite: categoryTreeAddServiceWrite ?? this.categoryTreeAddServiceWrite,
      categoryTreeAddServiceDocuments: categoryTreeAddServiceDocuments ?? this.categoryTreeAddServiceDocuments,
      categoryTreeDeleteServiceRead: categoryTreeDeleteServiceRead ?? this.categoryTreeDeleteServiceRead,
      categoryTreeDeleteServiceWrite: categoryTreeDeleteServiceWrite ?? this.categoryTreeDeleteServiceWrite,
      categoryTreeDeleteServiceDocuments: categoryTreeDeleteServiceDocuments ?? this.categoryTreeDeleteServiceDocuments,
      categoryTreeUpdateServiceRead: categoryTreeUpdateServiceRead?? this.categoryTreeUpdateServiceRead,
      categoryTreeUpdateServiceWrite: categoryTreeUpdateServiceWrite ?? this.categoryTreeUpdateServiceWrite,
      categoryTreeUpdateServiceDocuments: categoryTreeUpdateServiceDocuments?? this.categoryTreeUpdateServiceDocuments,
      uploadToFirebaseStorageMobileRead: uploadToFirebaseStorageMobileRead ?? this.uploadToFirebaseStorageMobileRead,
      uploadToFirebaseStorageMobileWrite: uploadToFirebaseStorageMobileWrite ?? this.uploadToFirebaseStorageMobileWrite,
      uploadToFirebaseStorageMobileDocuments: uploadToFirebaseStorageMobileDocuments ?? this.uploadToFirebaseStorageMobileDocuments,
      uploadToFirebaseStorageWebRead: uploadToFirebaseStorageWebRead ?? this.uploadToFirebaseStorageWebRead,
      uploadToFirebaseStorageWebWrite: uploadToFirebaseStorageWebWrite ?? this.uploadToFirebaseStorageWebWrite,
      uploadToFirebaseStorageWebDocuments: uploadToFirebaseStorageWebDocuments ?? this.uploadToFirebaseStorageWebDocuments,
      orderListRequestServiceRead: orderListRequestServiceRead ?? this.orderListRequestServiceRead,
      orderListRequestServiceWrite: orderListRequestServiceWrite ?? this.orderListRequestServiceWrite,
      orderListRequestServiceDocuments: orderListRequestServiceDocuments ?? this.orderListRequestServiceDocuments,
      orderRequestServiceRead: orderRequestServiceRead ?? this.orderRequestServiceRead,
      orderRequestServiceWrite: orderRequestServiceWrite ?? this.orderRequestServiceWrite,
      orderRequestServiceDocuments: orderRequestServiceDocuments ?? this.orderRequestServiceDocuments,
      orderUpdateServiceRead: orderUpdateServiceRead ?? this.orderUpdateServiceRead,
      orderUpdateServiceWrite: orderUpdateServiceWrite ?? this.orderUpdateServiceWrite,
      orderUpdateServiceDocuments: orderUpdateServiceDocuments ?? this.orderUpdateServiceDocuments,
      orderCreateServiceRead: orderCreateServiceRead ?? this.orderCreateServiceRead,
      orderCreateServiceWrite: orderCreateServiceWrite ?? this.orderCreateServiceWrite,
      orderCreateServiceDocuments: orderCreateServiceDocuments ?? this.orderCreateServiceDocuments,
      orderDeleteServiceRead: orderDeleteServiceRead ?? this.orderDeleteServiceRead,
      orderDeleteServiceWrite: orderDeleteServiceWrite ?? this.orderDeleteServiceWrite,
      orderDeleteServiceDocuments: orderDeleteServiceDocuments ?? this.orderDeleteServiceDocuments,
      pipelineListRequestServiceRead: pipelineListRequestServiceRead ?? this.pipelineListRequestServiceRead,
      pipelineListRequestServiceWrite: pipelineListRequestServiceWrite ?? this.pipelineListRequestServiceWrite,
      pipelineListRequestServiceDocuments: pipelineListRequestServiceDocuments ?? this.pipelineListRequestServiceDocuments,
      pipelineCreateServiceRead: pipelineCreateServiceRead ?? this.pipelineCreateServiceRead,
      pipelineCreateServiceWrite: pipelineCreateServiceWrite ?? this.pipelineCreateServiceWrite,
      pipelineCreateServiceDocuments: pipelineCreateServiceDocuments ?? this.pipelineCreateServiceDocuments,
      pipelineRequestServiceRead: pipelineRequestServiceRead ?? this.pipelineRequestServiceRead,
      pipelineRequestServiceWrite: pipelineRequestServiceWrite ?? this.pipelineRequestServiceWrite,
      pipelineRequestServiceDocuments: pipelineRequestServiceDocuments ?? this.pipelineRequestServiceDocuments,
      pipelineUpdateServiceRead: pipelineUpdateServiceRead ?? this.pipelineUpdateServiceRead,
      pipelineUpdateServiceWrite: pipelineUpdateServiceWrite ?? this.pipelineUpdateServiceWrite,
      pipelineUpdateServiceDocuments: pipelineUpdateServiceDocuments ?? this.pipelineUpdateServiceDocuments,
      serviceListRequestServiceRead: serviceListRequestServiceRead ?? this.serviceListRequestServiceRead,
      serviceListRequestServiceWrite: serviceListRequestServiceWrite ?? this.serviceListRequestServiceWrite,
      serviceListRequestServiceDocuments: serviceListRequestServiceDocuments ?? this.serviceListRequestServiceDocuments,
      serviceListAndNavigateRequestServiceRead: serviceListAndNavigateRequestServiceRead ?? this.serviceListAndNavigateRequestServiceRead,
      serviceListAndNavigateRequestServiceWrite: serviceListAndNavigateRequestServiceWrite ?? this.serviceListAndNavigateRequestServiceWrite,
      serviceListAndNavigateRequestServiceDocuments: serviceListAndNavigateRequestServiceDocuments?? this.serviceListAndNavigateRequestServiceDocuments,
      serviceListAndNavigateOnConfirmRequestServiceRead: serviceListAndNavigateOnConfirmRequestServiceRead?? this.serviceListAndNavigateOnConfirmRequestServiceRead,
      serviceListAndNavigateOnConfirmRequestServiceWrite: serviceListAndNavigateOnConfirmRequestServiceWrite ?? this.serviceListAndNavigateOnConfirmRequestServiceWrite,
      serviceListAndNavigateOnConfirmRequestServiceDocuments: serviceListAndNavigateOnConfirmRequestServiceDocuments ?? this.serviceListAndNavigateOnConfirmRequestServiceDocuments,
      serviceUpdateServiceRead: serviceUpdateServiceRead ?? this.serviceUpdateServiceRead,
      serviceUpdateServiceWrite: serviceUpdateServiceWrite ?? this.serviceUpdateServiceWrite,
      serviceUpdateServiceDocuments: serviceUpdateServiceDocuments ?? this.serviceUpdateServiceDocuments,
      serviceUpdateServiceVisibilityRead: serviceUpdateServiceVisibilityRead ?? this.serviceUpdateServiceVisibilityRead,
      serviceUpdateServiceVisibilityWrite: serviceUpdateServiceVisibilityWrite ?? this.serviceUpdateServiceVisibilityWrite,
      serviceUpdateServiceVisibilityDocuments: serviceUpdateServiceVisibilityDocuments ?? this.serviceUpdateServiceVisibilityDocuments,
      serviceCreateServiceRead: serviceCreateServiceRead ?? this.serviceCreateServiceRead,
      serviceCreateServiceWrite: serviceCreateServiceWrite ?? this.serviceCreateServiceWrite,
      serviceCreateServiceDocuments: serviceCreateServiceDocuments ?? this.serviceCreateServiceDocuments,
      stripePaymentAddPaymentMethodRead: stripePaymentAddPaymentMethodRead ?? this.stripePaymentAddPaymentMethodRead,
      stripePaymentAddPaymentMethodWrite: stripePaymentAddPaymentMethodWrite ?? this.stripePaymentAddPaymentMethodWrite,
      stripePaymentAddPaymentMethodDocuments: stripePaymentAddPaymentMethodDocuments ?? this.stripePaymentAddPaymentMethodDocuments,
      stripePaymentCardListRequestRead: stripePaymentCardListRequestRead ?? this.stripePaymentCardListRequestRead,
      stripePaymentCardListRequestWrite: stripePaymentCardListRequestWrite ?? this.stripePaymentCardListRequestWrite,
      stripePaymentCardListRequestDocuments: stripePaymentCardListRequestDocuments ?? this.stripePaymentCardListRequestDocuments,
      stripeDetachPaymentMethodRequestRead: stripeDetachPaymentMethodRequestRead ?? this.stripeDetachPaymentMethodRequestRead,
      stripeDetachPaymentMethodRequestWrite: stripeDetachPaymentMethodRequestWrite ?? this.stripeDetachPaymentMethodRequestWrite,
      stripeDetachPaymentMethodRequestDocuments: stripeDetachPaymentMethodRequestDocuments ?? this.stripeDetachPaymentMethodRequestDocuments,
      userRequestServiceRead: userRequestServiceRead ?? this.userRequestServiceRead,
      userRequestServiceWrite: userRequestServiceWrite ?? this.userRequestServiceWrite,
      userRequestServiceDocuments: userRequestServiceDocuments ?? this.userRequestServiceDocuments,
      userEditDeviceRead: userEditDeviceRead ?? this.userEditDeviceRead,
      userEditDeviceWrite: userEditDeviceWrite ?? this.userEditDeviceWrite,
      userEditDeviceDocuments: userEditDeviceDocuments ?? this.userEditDeviceDocuments,
      userEditTokenRead: userEditTokenRead ?? this.userEditTokenRead,
      userEditTokenWrite: userEditTokenWrite ?? this.userEditTokenWrite,
      userEditTokenDocuments: userEditTokenDocuments ?? this.userEditTokenDocuments,
    );
  }

  writeToStorage(StatisticsState state) async{
    await storage.write(key: 'bookingCreateRequestServiceRead', value: state.bookingCreateRequestServiceRead.toString());
    await storage.write(key: 'bookingCreateRequestServiceWrite', value: state.bookingCreateRequestServiceWrite.toString());
    await storage.write(key: 'bookingCreateRequestServiceDocuments', value: state.bookingCreateRequestServiceDocuments.toString());
    await storage.write(key: 'bookingRequestServiceRead', value: state.bookingRequestServiceRead.toString());
    await storage.write(key: 'bookingRequestServiceWrite', value: state.bookingRequestServiceWrite.toString());
    await storage.write(key: 'bookingRequestServiceDocuments', value: state.bookingRequestServiceDocuments.toString());
    await storage.write(key: 'userBookingListRequestServiceRead', value: state.userBookingListRequestServiceRead.toString());
    await storage.write(key: 'userBookingListRequestServiceWrite', value: state.userBookingListRequestServiceWrite.toString());
    await storage.write(key: 'userBookingListRequestServiceDocuments', value: state.userBookingListRequestServiceDocuments.toString());
    await storage.write(key: 'bookingListRequestServiceRead', value: state.bookingListRequestServiceRead.toString());
    await storage.write(key: 'bookingListRequestServiceWrite', value: state.bookingListRequestServiceWrite.toString());
    await storage.write(key: 'bookingListRequestServiceDocuments', value: state.bookingListRequestServiceDocuments.toString());
    await storage.write(key: 'bookingUpdateRequestServiceRead', value: state.bookingUpdateRequestServiceRead.toString());
    await storage.write(key: 'bookingUpdateRequestServiceWrite', value: state.bookingUpdateRequestServiceWrite.toString());
    await storage.write(key: 'bookingUpdateRequestServiceDocuments', value: state.bookingUpdateRequestServiceDocuments.toString());
    await storage.write(key: 'bookingUpdateAndNavigateRequestServiceRead', value: state.bookingUpdateAndNavigateRequestServiceRead.toString());
    await storage.write(key: 'bookingUpdateAndNavigateRequestServiceWrite', value: state.bookingUpdateAndNavigateRequestServiceWrite.toString());
    await storage.write(key: 'bookingUpdateAndNavigateRequestServiceDocuments', value: state.bookingUpdateAndNavigateRequestServiceDocuments.toString());
    await storage.write(key: 'businessListRequestServiceRead', value: state.businessListRequestServiceRead.toString());
    await storage.write(key: 'businessListRequestServiceWrite', value: state.businessListRequestServiceWrite.toString());
    await storage.write(key: 'businessListRequestServiceDocuments', value: state.businessListRequestServiceDocuments.toString());
    await storage.write(key: 'businessAndNavigateRequestServiceRead', value: state.businessAndNavigateRequestServiceRead.toString());
    await storage.write(key: 'businessAndNavigateRequestServiceWrite', value: state.businessAndNavigateRequestServiceWrite.toString());
    await storage.write(key: 'businessAndNavigateRequestServiceDocuments', value: state.businessAndNavigateRequestServiceDocuments.toString());
    await storage.write(key: 'businessAndNavigateOnConfirmRequestServiceRead', value: state.businessAndNavigateOnConfirmRequestServiceRead.toString());
    await storage.write(key: 'businessAndNavigateOnConfirmRequestServiceWrite', value: state.businessAndNavigateOnConfirmRequestServiceWrite.toString());
    await storage.write(key: 'businessAndNavigateOnConfirmRequestServiceDocuments', value: state.businessAndNavigateOnConfirmRequestServiceDocuments.toString());
    await storage.write(key: 'businessRequestServiceRead', value: state.businessRequestServiceRead.toString());
    await storage.write(key: 'businessRequestServiceWrite', value: state.businessRequestServiceWrite.toString());
    await storage.write(key: 'businessRequestServiceDocuments', value: state.businessRequestServiceDocuments.toString());
    await storage.write(key: 'businessUpdateServiceRead', value: state.businessUpdateServiceRead.toString());
    await storage.write(key: 'businessUpdateServiceWrite', value: state.businessUpdateServiceWrite.toString());
    await storage.write(key: 'businessUpdateServiceDocuments', value: state.businessUpdateServiceDocuments.toString());
    await storage.write(key: 'businessCreateServiceRead', value: state.businessCreateServiceRead.toString());
    await storage.write(key: 'businessCreateServiceWrite', value: state.businessCreateServiceWrite.toString());
    await storage.write(key: 'businessCreateServiceDocuments', value: state.businessCreateServiceDocuments.toString());
    await storage.write(key: 'categoryInviteRequestServiceRead', value: state.categoryInviteRequestServiceRead.toString());
    await storage.write(key: 'categoryInviteRequestServiceWrite', value: state.categoryInviteRequestServiceWrite.toString());
    await storage.write(key: 'categoryInviteRequestServiceDocuments', value: state.categoryInviteRequestServiceDocuments.toString());
    await storage.write(key: 'categoryInviteCreateServiceRead', value: state.categoryInviteCreateServiceRead.toString());
    await storage.write(key: 'categoryInviteCreateServiceWrite', value: state.categoryInviteCreateServiceWrite.toString());
    await storage.write(key: 'categoryInviteCreateServiceDocuments', value: state.categoryInviteCreateServiceDocuments.toString());
    await storage.write(key: 'categoryInviteDeleteServiceRead', value: state.categoryInviteDeleteServiceRead.toString());
    await storage.write(key: 'categoryInviteDeleteServiceWrite', value: state.categoryInviteDeleteServiceWrite.toString());
    await storage.write(key: 'categoryInviteDeleteServiceDocuments', value: state.categoryInviteDeleteServiceDocuments.toString());
    await storage.write(key: 'categoryListRequestServiceRead', value: state.categoryListRequestServiceRead.toString());
    await storage.write(key: 'categoryListRequestServiceWrite', value: state.categoryListRequestServiceWrite.toString());
    await storage.write(key: 'categoryListRequestServiceDocuments', value: state.categoryListRequestServiceDocuments.toString());
    await storage.write(key: 'userCategoryListRequestServiceRead', value: state.userCategoryListRequestServiceRead.toString());
    await storage.write(key: 'userCategoryListRequestServiceWrite', value: state.userCategoryListRequestServiceWrite.toString());
    await storage.write(key: 'userCategoryListRequestServiceDocuments', value: state.userCategoryListRequestServiceDocuments.toString());
    await storage.write(key: 'categoryRootListRequestServiceRead', value: state.categoryRootListRequestServiceRead.toString());
    await storage.write(key: 'categoryRootListRequestServiceWrite', value: state.categoryRootListRequestServiceWrite.toString());
    await storage.write(key: 'categoryRootListRequestServiceDocuments', value: state.categoryRootListRequestServiceDocuments.toString());
    await storage.write(key: 'categoryRequestServiceRead', value: state.categoryRequestServiceRead.toString());
    await storage.write(key: 'categoryRequestServiceWrite', value: state.categoryRequestServiceWrite.toString());
    await storage.write(key: 'categoryRequestServiceDocuments', value: state.categoryRequestServiceDocuments.toString());
    await storage.write(key: 'categoryInviteManagerServiceRead', value: state.categoryInviteManagerServiceRead.toString());
    await storage.write(key: 'categoryInviteManagerServiceWrite', value: state.categoryInviteManagerServiceWrite.toString());
    await storage.write(key: 'categoryInviteManagerServiceDocuments', value: state.categoryInviteManagerServiceDocuments.toString());
    await storage.write(key: 'categoryInviteWorkerServiceRead', value: state.categoryInviteWorkerServiceRead.toString());
    await storage.write(key: 'categoryInviteWorkerServiceWrite', value: state.categoryInviteWorkerServiceWrite.toString());
    await storage.write(key: 'categoryInviteWorkerServiceDocuments', value: state.categoryInviteWorkerServiceDocuments.toString());
    await storage.write(key: 'categoryDeleteManagerServiceRead', value: state.categoryDeleteManagerServiceRead.toString());
    await storage.write(key: 'categoryDeleteManagerServiceWrite', value: state.categoryDeleteManagerServiceWrite.toString());
    await storage.write(key: 'categoryDeleteManagerServiceDocuments', value: state.categoryDeleteManagerServiceDocuments.toString());
    await storage.write(key: 'categoryDeleteWorkerServiceRead', value: state.categoryDeleteWorkerServiceRead.toString());
    await storage.write(key: 'categoryDeleteWorkerServiceWrite', value: state.categoryDeleteWorkerServiceWrite.toString());
    await storage.write(key: 'categoryDeleteWorkerServiceDocuments', value: state.categoryDeleteWorkerServiceDocuments.toString());
    await storage.write(key: 'categoryUpdateServiceRead', value: state.categoryUpdateServiceRead.toString());
    await storage.write(key: 'categoryUpdateServiceWrite', value: state.categoryUpdateServiceWrite.toString());
    await storage.write(key: 'categoryUpdateServiceDocuments', value: state.categoryUpdateServiceDocuments.toString());
    await storage.write(key: 'categoryCreateServiceRead', value: state.categoryCreateServiceRead.toString());
    await storage.write(key: 'categoryCreateServiceWrite', value: state.categoryCreateServiceWrite.toString());
    await storage.write(key: 'categoryCreateServiceDocuments', value: state.categoryCreateServiceDocuments.toString());
    await storage.write(key: 'categoryDeleteServiceRead', value: state.categoryDeleteServiceRead.toString());
    await storage.write(key: 'categoryDeleteServiceWrite', value: state.categoryDeleteServiceWrite.toString());
    await storage.write(key: 'categoryDeleteServiceDocuments', value: state.categoryDeleteServiceDocuments.toString());
    await storage.write(key: 'categoryTreeCreateIfNotExistsServiceRead', value: state.categoryTreeCreateIfNotExistsServiceRead.toString());
    await storage.write(key: 'categoryTreeCreateIfNotExistsServiceWrite', value: state.categoryTreeCreateIfNotExistsServiceWrite.toString());
    await storage.write(key: 'categoryTreeCreateIfNotExistsServiceDocuments', value: state.categoryTreeCreateIfNotExistsServiceDocuments.toString());
    await storage.write(key: 'categoryTreeRequestServiceRead', value: state.categoryTreeRequestServiceRead.toString());
    await storage.write(key: 'categoryTreeRequestServiceWrite', value: state.categoryTreeRequestServiceWrite.toString());
    await storage.write(key: 'categoryTreeRequestServiceDocuments', value: state.categoryTreeRequestServiceDocuments.toString());
    await storage.write(key: 'categoryTreeAddServiceRead', value: state.categoryTreeAddServiceRead.toString());
    await storage.write(key: 'categoryTreeAddServiceWrite', value: state.categoryTreeAddServiceWrite.toString());
    await storage.write(key: 'categoryTreeAddServiceDocuments', value: state.categoryTreeAddServiceDocuments.toString());
    await storage.write(key: 'categoryTreeDeleteServiceRead', value: state.categoryTreeDeleteServiceRead.toString());
    await storage.write(key: 'categoryTreeDeleteServiceWrite', value: state.categoryTreeDeleteServiceWrite.toString());
    await storage.write(key: 'categoryTreeDeleteServiceDocuments', value: state.categoryTreeDeleteServiceDocuments.toString());
    await storage.write(key: 'categoryTreeUpdateServiceRead', value: state.categoryTreeUpdateServiceRead.toString());
    await storage.write(key: 'categoryTreeUpdateServiceWrite', value: state.categoryTreeUpdateServiceWrite.toString());
    await storage.write(key: 'categoryTreeUpdateServiceDocuments', value: state.categoryTreeUpdateServiceDocuments.toString());
    await storage.write(key: 'uploadToFirebaseStorageMobileRead', value: state.uploadToFirebaseStorageMobileRead.toString());
    await storage.write(key: 'uploadToFirebaseStorageMobileWrite', value: state.uploadToFirebaseStorageMobileWrite.toString());
    await storage.write(key: 'uploadToFirebaseStorageMobileDocuments', value: state.uploadToFirebaseStorageMobileDocuments.toString());
    await storage.write(key: 'uploadToFirebaseStorageWebRead', value: state.uploadToFirebaseStorageWebRead.toString());
    await storage.write(key: 'uploadToFirebaseStorageWebWrite', value: state.uploadToFirebaseStorageWebWrite.toString());
    await storage.write(key: 'uploadToFirebaseStorageWebDocuments', value: state.uploadToFirebaseStorageWebDocuments.toString());
    await storage.write(key: 'orderListRequestServiceRead', value: state.orderListRequestServiceRead.toString());
    await storage.write(key: 'orderListRequestServiceWrite', value: state.orderListRequestServiceWrite.toString());
    await storage.write(key: 'orderListRequestServiceDocuments', value: state.orderListRequestServiceDocuments.toString());
    await storage.write(key: 'orderRequestServiceRead', value: state.orderRequestServiceRead.toString());
    await storage.write(key: 'orderRequestServiceWrite', value: state.orderRequestServiceWrite.toString());
    await storage.write(key: 'orderRequestServiceDocuments', value: state.orderRequestServiceDocuments.toString());
    await storage.write(key: 'orderUpdateServiceRead', value: state.orderUpdateServiceRead.toString());
    await storage.write(key: 'orderUpdateServiceWrite', value: state.orderUpdateServiceWrite.toString());
    await storage.write(key: 'orderUpdateServiceDocuments', value: state.orderUpdateServiceDocuments.toString());
    await storage.write(key: 'orderCreateServiceRead', value: state.orderCreateServiceRead.toString());
    await storage.write(key: 'orderCreateServiceWrite', value: state.orderCreateServiceWrite.toString());
    await storage.write(key: 'orderCreateServiceDocuments', value: state.orderCreateServiceDocuments.toString());
    await storage.write(key: 'orderDeleteServiceRead', value: state.orderDeleteServiceRead.toString());
    await storage.write(key: 'orderDeleteServiceWrite', value: state.orderDeleteServiceWrite.toString());
    await storage.write(key: 'orderDeleteServiceDocuments', value: state.orderDeleteServiceDocuments.toString());
    await storage.write(key: 'pipelineListRequestServiceRead', value: state.pipelineListRequestServiceRead.toString());
    await storage.write(key: 'pipelineListRequestServiceWrite', value: state.pipelineListRequestServiceWrite.toString());
    await storage.write(key: 'pipelineListRequestServiceDocuments', value: state.pipelineListRequestServiceDocuments.toString());
    await storage.write(key: 'pipelineCreateServiceRead', value: state.pipelineCreateServiceRead.toString());
    await storage.write(key: 'pipelineCreateServiceWrite', value: state.pipelineCreateServiceWrite.toString());
    await storage.write(key: 'pipelineCreateServiceDocuments', value: state.pipelineCreateServiceDocuments.toString());
    await storage.write(key: 'pipelineRequestServiceRead', value: state.pipelineRequestServiceRead.toString());
    await storage.write(key: 'pipelineRequestServiceWrite', value: state.pipelineRequestServiceWrite.toString());
    await storage.write(key: 'pipelineRequestServiceDocuments', value: state.pipelineRequestServiceDocuments.toString());
    await storage.write(key: 'pipelineUpdateServiceRead', value: state.pipelineUpdateServiceRead.toString());
    await storage.write(key: 'pipelineUpdateServiceWrite', value: state.pipelineUpdateServiceWrite.toString());
    await storage.write(key: 'pipelineUpdateServiceDocuments', value: state.pipelineUpdateServiceDocuments.toString());
    await storage.write(key: 'serviceListRequestServiceRead', value: state.serviceListRequestServiceRead.toString());
    await storage.write(key: 'serviceListRequestServiceWrite', value: state.serviceListRequestServiceWrite.toString());
    await storage.write(key: 'serviceListRequestServiceDocuments', value: state.serviceListRequestServiceDocuments.toString());
    await storage.write(key: 'serviceListAndNavigateRequestServiceRead', value: state.serviceListAndNavigateRequestServiceRead.toString());
    await storage.write(key: 'serviceListAndNavigateRequestServiceWrite', value: state.serviceListAndNavigateRequestServiceWrite.toString());
    await storage.write(key: 'serviceListAndNavigateRequestServiceDocuments', value: state.serviceListAndNavigateRequestServiceDocuments.toString());
    await storage.write(key: 'serviceListAndNavigateOnConfirmRequestServiceRead', value: state.serviceListAndNavigateOnConfirmRequestServiceRead.toString());
    await storage.write(key: 'serviceListAndNavigateOnConfirmRequestServiceWrite', value: state.serviceListAndNavigateOnConfirmRequestServiceWrite.toString());
    await storage.write(key: 'serviceListAndNavigateOnConfirmRequestServiceDocuments', value: state.serviceListAndNavigateOnConfirmRequestServiceDocuments.toString());
    await storage.write(key: 'serviceUpdateServiceRead', value: state.serviceUpdateServiceRead.toString());
    await storage.write(key: 'serviceUpdateServiceWrite', value: state.serviceUpdateServiceWrite.toString());
    await storage.write(key: 'serviceUpdateServiceDocuments', value: state.serviceUpdateServiceDocuments.toString());
    await storage.write(key: 'serviceUpdateServiceVisibilityRead', value: state.serviceUpdateServiceVisibilityRead.toString());
    await storage.write(key: 'serviceUpdateServiceVisibilityWrite', value: state.serviceUpdateServiceVisibilityWrite.toString());
    await storage.write(key: 'serviceUpdateServiceVisibilityDocuments', value: state.serviceUpdateServiceVisibilityDocuments.toString());
    await storage.write(key: 'serviceCreateServiceRead', value: state.serviceCreateServiceRead.toString());
    await storage.write(key: 'serviceCreateServiceWrite', value: state.serviceCreateServiceWrite.toString());
    await storage.write(key: 'serviceCreateServiceDocuments', value: state.serviceCreateServiceDocuments.toString());
    await storage.write(key: 'stripePaymentAddPaymentMethodRead', value: state.stripePaymentAddPaymentMethodRead.toString());
    await storage.write(key: 'stripePaymentAddPaymentMethodWrite', value: state.stripePaymentAddPaymentMethodWrite.toString());
    await storage.write(key: 'stripePaymentAddPaymentMethodDocuments', value: state.stripePaymentAddPaymentMethodDocuments.toString());
    await storage.write(key: 'stripePaymentCardListRequestRead', value: state.stripePaymentCardListRequestRead.toString());
    await storage.write(key: 'stripePaymentCardListRequestWrite', value: state.stripePaymentCardListRequestWrite.toString());
    await storage.write(key: 'stripePaymentCardListRequestDocuments', value: state.stripePaymentCardListRequestDocuments.toString());
    await storage.write(key: 'stripeDetachPaymentMethodRequestRead', value: state.stripeDetachPaymentMethodRequestRead.toString());
    await storage.write(key: 'stripeDetachPaymentMethodRequestWrite', value: state.stripeDetachPaymentMethodRequestWrite.toString());
    await storage.write(key: 'stripeDetachPaymentMethodRequestDocuments', value: state.stripeDetachPaymentMethodRequestDocuments.toString());
    await storage.write(key: 'userRequestServiceRead', value: state.userRequestServiceRead.toString());
    await storage.write(key: 'userRequestServiceWrite', value: state.userRequestServiceWrite.toString());
    await storage.write(key: 'userRequestServiceDocuments', value: state.userRequestServiceDocuments.toString());
    await storage.write(key: 'userEditDeviceRead', value: state.userEditDeviceRead.toString());
    await storage.write(key: 'userEditDeviceWrite', value: state.userEditDeviceWrite.toString());
    await storage.write(key: 'userEditDeviceDocuments', value: state.userEditDeviceDocuments.toString());
    await storage.write(key: 'userEditTokenRead', value: state.userEditTokenRead.toString());
    await storage.write(key: 'userEditTokenWrite', value: state.userEditTokenWrite.toString());
    await storage.write(key: 'userEditTokenDocuments', value: state.userEditTokenDocuments.toString());
  }

  Future<StatisticsState> readFromStorage() async{
    StatisticsState state = StatisticsState().toEmpty();
    state.bookingCreateRequestServiceRead = int.parse(await storage.read(key: 'bookingCreateRequestServiceRead') ?? '0');
    state.bookingCreateRequestServiceWrite = int.parse(await storage.read(key: 'bookingCreateRequestServiceWrite') ?? '0');
    state.bookingCreateRequestServiceDocuments = int.parse(await storage.read(key: 'bookingCreateRequestServiceDocuments') ?? '0');
    state.bookingRequestServiceRead = int.parse(await storage.read(key: 'bookingRequestServiceRead') ?? '0');
    state.bookingRequestServiceWrite = int.parse(await storage.read(key: 'bookingRequestServiceWrite') ?? '0');
    state.bookingRequestServiceDocuments = int.parse(await storage.read(key: 'bookingRequestServiceDocuments') ?? '0');
    state.userBookingListRequestServiceRead = int.parse(await storage.read(key: 'userBookingListRequestServiceRead') ?? '0');
    state.userBookingListRequestServiceWrite = int.parse(await storage.read(key: 'userBookingListRequestServiceWrite') ?? '0');
    state.userBookingListRequestServiceDocuments = int.parse(await storage.read(key: 'userBookingListRequestServiceDocuments') ?? '0');
    state.bookingListRequestServiceRead = int.parse(await storage.read(key: 'bookingListRequestServiceRead') ?? '0');
    state.bookingListRequestServiceWrite = int.parse(await storage.read(key: 'bookingListRequestServiceWrite') ?? '0');
    state.bookingListRequestServiceDocuments = int.parse(await storage.read(key: 'bookingListRequestServiceDocuments') ?? '0');
    state.bookingUpdateRequestServiceRead = int.parse(await storage.read(key: 'bookingUpdateRequestServiceRead') ?? '0');
    state.bookingUpdateRequestServiceWrite = int.parse(await storage.read(key: 'bookingUpdateRequestServiceWrite') ?? '0');
    state.bookingUpdateRequestServiceDocuments = int.parse(await storage.read(key: 'bookingUpdateRequestServiceDocuments') ?? '0');
    state.bookingUpdateAndNavigateRequestServiceRead = int.parse(await storage.read(key: 'bookingUpdateAndNavigateRequestServiceRead') ?? '0');
    state.bookingUpdateAndNavigateRequestServiceWrite = int.parse(await storage.read(key: 'bookingUpdateAndNavigateRequestServiceWrite') ?? '0');
    state.bookingUpdateAndNavigateRequestServiceDocuments = int.parse(await storage.read(key: 'bookingUpdateAndNavigateRequestServiceDocuments') ?? '0');
    state.businessListRequestServiceRead = int.parse(await storage.read(key: 'businessListRequestServiceRead') ?? '0');
    state.businessListRequestServiceWrite = int.parse(await storage.read(key: 'businessListRequestServiceWrite') ?? '0');
    state.businessListRequestServiceDocuments = int.parse(await storage.read(key: 'businessListRequestServiceDocuments') ?? '0');
    state.businessAndNavigateRequestServiceRead = int.parse(await storage.read(key: 'businessAndNavigateRequestServiceRead') ?? '0');
    state.businessAndNavigateRequestServiceWrite = int.parse(await storage.read(key: 'businessAndNavigateRequestServiceWrite') ?? '0');
    state.businessAndNavigateRequestServiceDocuments = int.parse(await storage.read(key: 'businessAndNavigateRequestServiceDocuments') ?? '0');
    state.businessAndNavigateOnConfirmRequestServiceRead = int.parse(await storage.read(key: 'businessAndNavigateOnConfirmRequestServiceRead') ?? '0');
    state.businessAndNavigateOnConfirmRequestServiceWrite = int.parse(await storage.read(key: 'businessAndNavigateOnConfirmRequestServiceWrite') ?? '0');
    state.businessAndNavigateOnConfirmRequestServiceDocuments = int.parse(await storage.read(key: 'businessAndNavigateOnConfirmRequestServiceDocuments') ?? '0');
    state.businessRequestServiceRead = int.parse(await storage.read(key: 'businessRequestServiceRead') ?? '0');
    state.businessRequestServiceWrite = int.parse(await storage.read(key: 'businessRequestServiceWrite') ?? '0');
    state.businessRequestServiceDocuments = int.parse(await storage.read(key: 'businessRequestServiceDocuments') ?? '0');
    state.businessUpdateServiceRead = int.parse(await storage.read(key: 'businessUpdateServiceRead') ?? '0');
    state.businessUpdateServiceWrite = int.parse(await storage.read(key: 'businessUpdateServiceWrite') ?? '0');
    state.businessUpdateServiceDocuments = int.parse(await storage.read(key: 'businessUpdateServiceDocuments') ?? '0');
    state.businessCreateServiceRead = int.parse(await storage.read(key: 'businessCreateServiceRead') ?? '0');
    state.businessCreateServiceWrite = int.parse(await storage.read(key: 'businessCreateServiceWrite') ?? '0');
    state.businessCreateServiceDocuments = int.parse(await storage.read(key: 'businessCreateServiceDocuments') ?? '0');
    state.categoryInviteRequestServiceRead = int.parse(await storage.read(key: 'categoryInviteRequestServiceRead') ?? '0');
    state.categoryInviteRequestServiceWrite = int.parse(await storage.read(key: 'categoryInviteRequestServiceWrite') ?? '0');
    state.categoryInviteRequestServiceDocuments = int.parse(await storage.read(key: 'categoryInviteRequestServiceDocuments') ?? '0');
    state.categoryInviteCreateServiceRead = int.parse(await storage.read(key: 'categoryInviteCreateServiceRead') ?? '0');
    state.categoryInviteCreateServiceWrite = int.parse(await storage.read(key: 'categoryInviteCreateServiceWrite') ?? '0');
    state.categoryInviteCreateServiceDocuments = int.parse(await storage.read(key: 'categoryInviteCreateServiceDocuments') ?? '0');
    state.categoryInviteDeleteServiceRead = int.parse(await storage.read(key: 'categoryInviteDeleteServiceRead') ?? '0');
    state.categoryInviteDeleteServiceWrite = int.parse(await storage.read(key: 'categoryInviteDeleteServiceWrite') ?? '0');
    state.categoryInviteDeleteServiceDocuments = int.parse(await storage.read(key: 'categoryInviteDeleteServiceDocuments') ?? '0');
    state.categoryListRequestServiceRead = int.parse(await storage.read(key: 'categoryListRequestServiceRead') ?? '0');
    state.categoryListRequestServiceWrite = int.parse(await storage.read(key: 'categoryListRequestServiceWrite') ?? '0');
    state.categoryListRequestServiceDocuments = int.parse(await storage.read(key: 'categoryListRequestServiceDocuments') ?? '0');
    state.userCategoryListRequestServiceRead = int.parse(await storage.read(key: 'userCategoryListRequestServiceRead') ?? '0');
    state.userCategoryListRequestServiceWrite = int.parse(await storage.read(key: 'userCategoryListRequestServiceWrite') ?? '0');
    state.userCategoryListRequestServiceDocuments = int.parse(await storage.read(key: 'userCategoryListRequestServiceDocuments') ?? '0');
    state.categoryRootListRequestServiceRead = int.parse(await storage.read(key: 'categoryRootListRequestServiceRead') ?? '0');
    state.categoryRootListRequestServiceWrite = int.parse(await storage.read(key: 'categoryRootListRequestServiceWrite') ?? '0');
    state.categoryRootListRequestServiceDocuments = int.parse(await storage.read(key: 'categoryRootListRequestServiceDocuments') ?? '0');
    state.categoryRequestServiceRead = int.parse(await storage.read(key: 'categoryRequestServiceRead') ?? '0');
    state.categoryRequestServiceWrite = int.parse(await storage.read(key: 'categoryRequestServiceWrite') ?? '0');
    state.categoryRequestServiceDocuments = int.parse(await storage.read(key: 'categoryRequestServiceDocuments') ?? '0');
    state.categoryInviteManagerServiceRead = int.parse(await storage.read(key: 'categoryInviteManagerServiceRead') ?? '0');
    state.categoryInviteManagerServiceWrite = int.parse(await storage.read(key: 'categoryInviteManagerServiceWrite') ?? '0');
    state.categoryInviteManagerServiceDocuments = int.parse(await storage.read(key: 'categoryInviteManagerServiceDocuments') ?? '0');
    state.categoryInviteWorkerServiceRead = int.parse(await storage.read(key: 'categoryInviteWorkerServiceRead') ?? '0');
    state.categoryInviteWorkerServiceWrite = int.parse(await storage.read(key: 'categoryInviteWorkerServiceWrite') ?? '0');
    state.categoryInviteWorkerServiceDocuments = int.parse(await storage.read(key: 'categoryInviteWorkerServiceDocuments') ?? '0');
    state.categoryDeleteManagerServiceRead = int.parse(await storage.read(key: 'categoryDeleteManagerServiceRead') ?? '0');
    state.categoryDeleteManagerServiceWrite = int.parse(await storage.read(key: 'categoryDeleteManagerServiceWrite') ?? '0');
    state.categoryDeleteManagerServiceDocuments = int.parse(await storage.read(key: 'categoryDeleteManagerServiceDocuments') ?? '0');
    state.categoryDeleteWorkerServiceRead = int.parse(await storage.read(key: 'categoryDeleteWorkerServiceRead') ?? '0');
    state.categoryDeleteWorkerServiceWrite = int.parse(await storage.read(key: 'categoryDeleteWorkerServiceWrite') ?? '0');
    state.categoryDeleteWorkerServiceDocuments = int.parse(await storage.read(key: 'categoryDeleteWorkerServiceDocuments') ?? '0');
    state.categoryUpdateServiceRead = int.parse(await storage.read(key: 'categoryUpdateServiceRead') ?? '0');
    state.categoryUpdateServiceWrite = int.parse(await storage.read(key: 'categoryUpdateServiceWrite') ?? '0');
    state.categoryUpdateServiceDocuments = int.parse(await storage.read(key: 'categoryUpdateServiceDocuments') ?? '0');
    state.categoryCreateServiceRead = int.parse(await storage.read(key: 'categoryCreateServiceRead') ?? '0');
    state.categoryCreateServiceWrite = int.parse(await storage.read(key: 'categoryCreateServiceWrite') ?? '0');
    state.categoryCreateServiceDocuments = int.parse(await storage.read(key: 'categoryCreateServiceDocuments') ?? '0');
    state.categoryDeleteServiceRead = int.parse(await storage.read(key: 'categoryDeleteServiceRead') ?? '0');
    state.categoryDeleteServiceWrite = int.parse(await storage.read(key: 'categoryDeleteServiceWrite') ?? '0');
    state.categoryDeleteServiceDocuments = int.parse(await storage.read(key: 'categoryDeleteServiceDocuments') ?? '0');
    state.categoryTreeCreateIfNotExistsServiceRead = int.parse(await storage.read(key: 'categoryTreeCreateIfNotExistsServiceRead') ?? '0');
    state.categoryTreeCreateIfNotExistsServiceWrite = int.parse(await storage.read(key: 'categoryTreeCreateIfNotExistsServiceWrite') ?? '0');
    state.categoryTreeCreateIfNotExistsServiceDocuments = int.parse(await storage.read(key: 'categoryTreeCreateIfNotExistsServiceDocuments') ?? '0');
    state.categoryTreeRequestServiceRead = int.parse(await storage.read(key: 'categoryTreeRequestServiceRead') ?? '0');
    state.categoryTreeRequestServiceWrite = int.parse(await storage.read(key: 'categoryTreeRequestServiceWrite') ?? '0');
    state.categoryTreeRequestServiceDocuments = int.parse(await storage.read(key: 'categoryTreeRequestServiceDocuments') ?? '0');
    state.categoryTreeAddServiceRead = int.parse(await storage.read(key: 'categoryTreeAddServiceRead') ?? '0');
    state.categoryTreeAddServiceWrite = int.parse(await storage.read(key: 'categoryTreeAddServiceWrite') ?? '0');
    state.categoryTreeAddServiceDocuments = int.parse(await storage.read(key: 'categoryTreeAddServiceDocuments') ?? '0');
    state.categoryTreeDeleteServiceRead = int.parse(await storage.read(key: 'categoryTreeDeleteServiceRead') ?? '0');
    state.categoryTreeDeleteServiceWrite = int.parse(await storage.read(key: 'categoryTreeDeleteServiceWrite') ?? '0');
    state.categoryTreeDeleteServiceDocuments = int.parse(await storage.read(key: 'categoryTreeDeleteServiceDocuments') ?? '0');
    state.categoryTreeUpdateServiceRead = int.parse(await storage.read(key: 'categoryTreeUpdateServiceRead') ?? '0');
    state.categoryTreeUpdateServiceWrite = int.parse(await storage.read(key: 'categoryTreeUpdateServiceWrite') ?? '0');
    state.categoryTreeUpdateServiceDocuments = int.parse(await storage.read(key: 'categoryTreeUpdateServiceDocuments') ?? '0');
    state.uploadToFirebaseStorageMobileRead = int.parse(await storage.read(key: 'uploadToFirebaseStorageMobileRead') ?? '0');
    state.uploadToFirebaseStorageMobileWrite = int.parse(await storage.read(key: 'uploadToFirebaseStorageMobileWrite') ?? '0');
    state.uploadToFirebaseStorageMobileDocuments = int.parse(await storage.read(key: 'uploadToFirebaseStorageMobileDocuments') ?? '0');
    state.uploadToFirebaseStorageWebRead = int.parse(await storage.read(key: 'uploadToFirebaseStorageWebRead') ?? '0');
    state.uploadToFirebaseStorageWebWrite = int.parse(await storage.read(key: 'uploadToFirebaseStorageWebWrite') ?? '0');
    state.uploadToFirebaseStorageWebDocuments = int.parse(await storage.read(key: 'uploadToFirebaseStorageWebDocuments') ?? '0');
    state.orderListRequestServiceRead = int.parse(await storage.read(key: 'orderListRequestServiceRead') ?? '0');
    state.orderListRequestServiceWrite = int.parse(await storage.read(key: 'orderListRequestServiceWrite') ?? '0');
    state.orderListRequestServiceDocuments = int.parse(await storage.read(key: 'orderListRequestServiceDocuments') ?? '0');
    state.orderRequestServiceRead = int.parse(await storage.read(key: 'orderRequestServiceRead') ?? '0');
    state.orderRequestServiceWrite = int.parse(await storage.read(key: 'orderRequestServiceWrite') ?? '0');
    state.orderRequestServiceDocuments = int.parse(await storage.read(key: 'orderRequestServiceDocuments') ?? '0');
    state.orderUpdateServiceRead = int.parse(await storage.read(key: 'orderUpdateServiceRead') ?? '0');
    state.orderUpdateServiceWrite = int.parse(await storage.read(key: 'orderUpdateServiceWrite') ?? '0');
    state.orderUpdateServiceDocuments = int.parse(await storage.read(key: 'orderUpdateServiceDocuments') ?? '0');
    state.orderCreateServiceRead = int.parse(await storage.read(key: 'orderCreateServiceRead') ?? '0');
    state.orderCreateServiceWrite = int.parse(await storage.read(key: 'orderCreateServiceWrite') ?? '0');
    state.orderCreateServiceDocuments = int.parse(await storage.read(key: 'orderCreateServiceDocuments') ?? '0');
    state.orderDeleteServiceRead = int.parse(await storage.read(key: 'orderDeleteServiceRead') ?? '0');
    state.orderDeleteServiceWrite = int.parse(await storage.read(key: 'orderDeleteServiceWrite') ?? '0');
    state.orderDeleteServiceDocuments = int.parse(await storage.read(key: 'orderDeleteServiceDocuments') ?? '0');
    state.pipelineListRequestServiceRead = int.parse(await storage.read(key: 'pipelineListRequestServiceRead') ?? '0');
    state.pipelineListRequestServiceWrite = int.parse(await storage.read(key: 'pipelineListRequestServiceWrite') ?? '0');
    state.pipelineListRequestServiceDocuments = int.parse(await storage.read(key: 'pipelineListRequestServiceDocuments') ?? '0');
    state.pipelineCreateServiceRead = int.parse(await storage.read(key: 'pipelineCreateServiceRead') ?? '0');
    state.pipelineCreateServiceWrite = int.parse(await storage.read(key: 'pipelineCreateServiceWrite') ?? '0');
    state.pipelineCreateServiceDocuments = int.parse(await storage.read(key: 'pipelineCreateServiceDocuments') ?? '0');
    state.pipelineRequestServiceRead = int.parse(await storage.read(key: 'pipelineRequestServiceRead') ?? '0');
    state.pipelineRequestServiceWrite = int.parse(await storage.read(key: 'pipelineRequestServiceWrite') ?? '0');
    state.pipelineRequestServiceDocuments = int.parse(await storage.read(key: 'pipelineRequestServiceDocuments') ?? '0');
    state.pipelineUpdateServiceRead = int.parse(await storage.read(key: 'pipelineUpdateServiceRead') ?? '0');
    state.pipelineUpdateServiceWrite = int.parse(await storage.read(key: 'pipelineUpdateServiceWrite') ?? '0');
    state.pipelineUpdateServiceDocuments = int.parse(await storage.read(key: 'pipelineUpdateServiceDocuments') ?? '0');
    state.serviceListRequestServiceRead = int.parse(await storage.read(key: 'serviceListRequestServiceRead') ?? '0');
    state.serviceListRequestServiceWrite = int.parse(await storage.read(key: 'serviceListRequestServiceWrite') ?? '0');
    state.serviceListRequestServiceDocuments = int.parse(await storage.read(key: 'serviceListRequestServiceDocuments') ?? '0');
    state.serviceListAndNavigateRequestServiceRead = int.parse(await storage.read(key: 'serviceListAndNavigateRequestServiceRead') ?? '0');
    state.serviceListAndNavigateRequestServiceWrite = int.parse(await storage.read(key: 'serviceListAndNavigateRequestServiceWrite') ?? '0');
    state.serviceListAndNavigateRequestServiceDocuments = int.parse(await storage.read(key: 'serviceListAndNavigateRequestServiceDocuments') ?? '0');
    state.serviceListAndNavigateOnConfirmRequestServiceRead = int.parse(await storage.read(key: 'serviceListAndNavigateOnConfirmRequestServiceRead') ?? '0');
    state.serviceListAndNavigateOnConfirmRequestServiceWrite = int.parse(await storage.read(key: 'serviceListAndNavigateOnConfirmRequestServiceWrite') ?? '0');
    state.serviceListAndNavigateOnConfirmRequestServiceDocuments = int.parse(await storage.read(key: 'serviceListAndNavigateOnConfirmRequestServiceDocuments') ?? '0');
    state.serviceUpdateServiceRead = int.parse(await storage.read(key: 'serviceUpdateServiceRead') ?? '0');
    state.serviceUpdateServiceWrite = int.parse(await storage.read(key: 'serviceUpdateServiceWrite') ?? '0');
    state.serviceUpdateServiceDocuments = int.parse(await storage.read(key: 'serviceUpdateServiceDocuments') ?? '0');
    state.serviceUpdateServiceVisibilityRead = int.parse(await storage.read(key: 'serviceUpdateServiceVisibilityRead') ?? '0');
    state.serviceUpdateServiceVisibilityWrite = int.parse(await storage.read(key: 'serviceUpdateServiceVisibilityWrite') ?? '0');
    state.serviceUpdateServiceVisibilityDocuments = int.parse(await storage.read(key: 'serviceUpdateServiceVisibilityDocuments') ?? '0');
    state.serviceCreateServiceRead = int.parse(await storage.read(key: 'serviceCreateServiceRead') ?? '0');
    state.serviceCreateServiceWrite = int.parse(await storage.read(key: 'serviceCreateServiceWrite') ?? '0');
    state.serviceCreateServiceDocuments = int.parse(await storage.read(key: 'serviceCreateServiceDocuments') ?? '0');
    state.stripePaymentAddPaymentMethodRead = int.parse(await storage.read(key: 'stripePaymentAddPaymentMethodRead') ?? '0');
    state.stripePaymentAddPaymentMethodWrite = int.parse(await storage.read(key: 'stripePaymentAddPaymentMethodWrite') ?? '0');
    state.stripePaymentAddPaymentMethodDocuments = int.parse(await storage.read(key: 'stripePaymentAddPaymentMethodDocuments') ?? '0');
    state.stripePaymentCardListRequestRead = int.parse(await storage.read(key: 'stripePaymentCardListRequestRead') ?? '0');
    state.stripePaymentCardListRequestWrite = int.parse(await storage.read(key: 'stripePaymentCardListRequestWrite') ?? '0');
    state.stripePaymentCardListRequestDocuments = int.parse(await storage.read(key: 'stripePaymentCardListRequestDocuments') ?? '0');
    state.stripeDetachPaymentMethodRequestRead = int.parse(await storage.read(key: 'stripeDetachPaymentMethodRequestRead') ?? '0');
    state.stripeDetachPaymentMethodRequestWrite = int.parse(await storage.read(key: 'stripeDetachPaymentMethodRequestWrite') ?? '0');
    state.stripeDetachPaymentMethodRequestDocuments = int.parse(await storage.read(key: 'stripeDetachPaymentMethodRequestDocuments') ?? '0');
    state.userRequestServiceRead = int.parse(await storage.read(key: 'userRequestServiceRead') ?? '0');
    state.userRequestServiceWrite = int.parse(await storage.read(key: 'userRequestServiceWrite') ?? '0');
    state.userRequestServiceDocuments = int.parse(await storage.read(key: 'userRequestServiceDocuments') ?? '0');
    state.userEditDeviceRead = int.parse(await storage.read(key: 'userEditDeviceRead') ?? '0');
    state.userEditDeviceWrite = int.parse(await storage.read(key: 'userEditDeviceWrite') ?? '0');
    state.userEditDeviceDocuments = int.parse(await storage.read(key: 'userEditDeviceDocuments') ?? '0');
    state.userEditTokenRead = int.parse(await storage.read(key: 'userEditTokenRead') ?? '0');
    state.userEditTokenWrite = int.parse(await storage.read(key: 'userEditTokenWrite') ?? '0');
    state.userEditTokenDocuments = int.parse(await storage.read(key: 'userEditTokenDocuments') ?? '0');

    return state;
  }

  void log(String from, StatisticsState statisticsState){
    debugPrint('$from - BookingCreateRequestService => READS: ${statisticsState.bookingCreateRequestServiceRead}, WRITES: ${statisticsState.bookingCreateRequestServiceWrite}, DOCUMENTS: ${statisticsState.bookingCreateRequestServiceDocuments}');
    debugPrint('$from - BookingRequestService => READS: ${statisticsState.bookingRequestServiceRead}, WRITES: ${statisticsState.bookingRequestServiceWrite}, DOCUMENTS: ${statisticsState.bookingRequestServiceDocuments}');
    debugPrint('$from - UserBookingListRequestService => READS: ${statisticsState.userBookingListRequestServiceRead}, WRITES: ${statisticsState.userBookingListRequestServiceWrite}, DOCUMENTS: ${statisticsState.userBookingListRequestServiceDocuments}');
    debugPrint('$from - BookingListRequestService => READS: ${statisticsState.bookingListRequestServiceRead}, WRITES: ${statisticsState.bookingListRequestServiceWrite}, DOCUMENTS: ${statisticsState.bookingListRequestServiceDocuments}');
    debugPrint('$from - BookingUpdateRequestService => READS: ${statisticsState.bookingUpdateRequestServiceRead}, WRITES: ${statisticsState.bookingUpdateRequestServiceWrite}, DOCUMENTS: ${statisticsState.bookingUpdateRequestServiceDocuments}');
    debugPrint('$from - BookingUpdateAndNavigateRequestService => READS: ${statisticsState.bookingUpdateAndNavigateRequestServiceRead}, WRITES: ${statisticsState.bookingUpdateAndNavigateRequestServiceWrite}, DOCUMENTS: ${statisticsState.bookingUpdateAndNavigateRequestServiceDocuments}');

    debugPrint('$from - BusinessListRequestService => READS: ${statisticsState.businessListRequestServiceRead}, WRITES: ${statisticsState.businessListRequestServiceWrite}, DOCUMENTS: ${statisticsState.businessListRequestServiceDocuments}');
    debugPrint('$from - BusinessAndNavigateRequestService => READS: ${statisticsState.businessAndNavigateRequestServiceRead}, WRITES: ${statisticsState.businessAndNavigateRequestServiceWrite}, DOCUMENTS: ${statisticsState.businessAndNavigateRequestServiceDocuments}');
    debugPrint('$from - BusinessAndNavigateOnConfirmRequestService => READS: ${statisticsState.businessAndNavigateOnConfirmRequestServiceRead}, WRITES: ${statisticsState.businessAndNavigateOnConfirmRequestServiceWrite}, DOCUMENTS: ${statisticsState.businessAndNavigateOnConfirmRequestServiceDocuments}');
    debugPrint('$from - BusinessRequestService => READS: ${statisticsState.businessRequestServiceRead}, WRITES: ${statisticsState.businessRequestServiceWrite}, DOCUMENTS: ${statisticsState.businessRequestServiceDocuments}');
    debugPrint('$from - BusinessUpdateService => READS: ${statisticsState.businessUpdateServiceRead}, WRITES: ${statisticsState.businessUpdateServiceWrite}, DOCUMENTS: ${statisticsState.businessUpdateServiceDocuments}');
    debugPrint('$from - BusinessCreateService => READS: ${statisticsState.businessCreateServiceRead}, WRITES: ${statisticsState.businessCreateServiceWrite}, DOCUMENTS: ${statisticsState.businessCreateServiceDocuments}');

    debugPrint('$from - CategoryInviteRequestService => READS: ${statisticsState.categoryInviteRequestServiceRead}, WRITES: ${statisticsState.categoryInviteRequestServiceWrite}, DOCUMENTS: ${statisticsState.categoryInviteRequestServiceDocuments}');
    debugPrint('$from - CategoryInviteCreateService => READS: ${statisticsState.categoryInviteCreateServiceRead}, WRITES: ${statisticsState.categoryInviteCreateServiceWrite}, DOCUMENTS: ${statisticsState.categoryInviteCreateServiceDocuments}');
    debugPrint('$from - CategoryInviteDeleteService => READS: ${statisticsState.categoryInviteDeleteServiceRead}, WRITES: ${statisticsState.categoryInviteDeleteServiceWrite}, DOCUMENTS: ${statisticsState.categoryInviteDeleteServiceDocuments}');

    debugPrint('$from - CategoryListRequestService => READS: ${statisticsState.categoryListRequestServiceRead}, WRITES: ${statisticsState.categoryListRequestServiceWrite}, DOCUMENTS: ${statisticsState.categoryListRequestServiceDocuments}');
    debugPrint('$from - UserCategoryListRequestService => READS: ${statisticsState.userCategoryListRequestServiceRead}, WRITES: ${statisticsState.userCategoryListRequestServiceWrite}, DOCUMENTS: ${statisticsState.userCategoryListRequestServiceDocuments}');
    debugPrint('$from - CategoryRootListRequestService => READS: ${statisticsState.categoryRootListRequestServiceRead}, WRITES: ${statisticsState.categoryRootListRequestServiceWrite}, DOCUMENTS: ${statisticsState.categoryRootListRequestServiceDocuments}');
    debugPrint('$from - CategoryRequestService => READS: ${statisticsState.categoryRequestServiceRead}, WRITES: ${statisticsState.categoryRequestServiceWrite}, DOCUMENTS: ${statisticsState.categoryRequestServiceDocuments}');
    debugPrint('$from - CategoryInviteManagerService => READS: ${statisticsState.categoryInviteManagerServiceRead}, WRITES: ${statisticsState.categoryInviteManagerServiceWrite}, DOCUMENTS: ${statisticsState.categoryInviteManagerServiceDocuments}');
    debugPrint('$from - CategoryInviteWorkerService => READS: ${statisticsState.categoryInviteWorkerServiceRead}, WRITES: ${statisticsState.categoryInviteWorkerServiceWrite}, DOCUMENTS: ${statisticsState.categoryInviteWorkerServiceDocuments}');
    debugPrint('$from - CategoryDeleteManagerService => READS: ${statisticsState.categoryDeleteManagerServiceRead}, WRITES: ${statisticsState.categoryDeleteManagerServiceWrite}, DOCUMENTS: ${statisticsState.categoryDeleteManagerServiceDocuments}');
    debugPrint('$from - CategoryDeleteWorkerService => READS: ${statisticsState.categoryDeleteWorkerServiceRead}, WRITES: ${statisticsState.categoryDeleteWorkerServiceWrite}, DOCUMENTS: ${statisticsState.categoryDeleteWorkerServiceDocuments}');
    debugPrint('$from - CategoryUpdateService => READS: ${statisticsState.categoryUpdateServiceRead}, WRITES: ${statisticsState.categoryUpdateServiceWrite}, DOCUMENTS: ${statisticsState.categoryUpdateServiceDocuments}');
    debugPrint('$from - CategoryCreateService => READS: ${statisticsState.categoryCreateServiceRead}, WRITES: ${statisticsState.categoryCreateServiceWrite}, DOCUMENTS: ${statisticsState.categoryCreateServiceDocuments}');
    debugPrint('$from - CategoryDeleteService => READS: ${statisticsState.categoryDeleteServiceRead}, WRITES: ${statisticsState.categoryDeleteServiceWrite}, DOCUMENTS: ${statisticsState.categoryDeleteServiceDocuments}');

    debugPrint('$from - CategoryTreeCreateIfNotExistsService => READS: ${statisticsState.categoryTreeCreateIfNotExistsServiceRead}, WRITES: ${statisticsState.categoryTreeCreateIfNotExistsServiceWrite}, DOCUMENTS: ${statisticsState.categoryTreeCreateIfNotExistsServiceDocuments}');
    debugPrint('$from - CategoryTreeRequestService => READS: ${statisticsState.categoryTreeRequestServiceRead}, WRITES: ${statisticsState.categoryTreeRequestServiceWrite}, DOCUMENTS: ${statisticsState.categoryTreeRequestServiceDocuments}');
    debugPrint('$from - CategoryTreeAddService => READS: ${statisticsState.categoryTreeAddServiceRead}, WRITES: ${statisticsState.categoryTreeAddServiceWrite}, DOCUMENTS: ${statisticsState.categoryTreeAddServiceDocuments}');
    debugPrint('$from - CategoryTreeDeleteService => READS: ${statisticsState.categoryTreeDeleteServiceRead}, WRITES: ${statisticsState.categoryTreeDeleteServiceWrite}, DOCUMENTS: ${statisticsState.categoryTreeDeleteServiceDocuments}');
    debugPrint('$from - CategoryTreeUpdateService => READS: ${statisticsState.categoryTreeUpdateServiceRead}, WRITES: ${statisticsState.categoryTreeUpdateServiceWrite}, DOCUMENTS: ${statisticsState.categoryTreeUpdateServiceDocuments}');

    debugPrint('$from - uploadToFirebaseStorageMobile => READS: ${statisticsState.uploadToFirebaseStorageMobileRead}, WRITES: ${statisticsState.uploadToFirebaseStorageMobileWrite}, DOCUMENTS: ${statisticsState.uploadToFirebaseStorageMobileDocuments}');
    debugPrint('$from - uploadToFirebaseStorageWeb => READS: ${statisticsState.uploadToFirebaseStorageWebRead}, WRITES: ${statisticsState.uploadToFirebaseStorageWebWrite}, DOCUMENTS: ${statisticsState.uploadToFirebaseStorageWebDocuments}');

    debugPrint('$from - OrderListRequestService => READS: ${statisticsState.orderListRequestServiceRead}, WRITES: ${statisticsState.orderListRequestServiceWrite}, DOCUMENTS: ${statisticsState.orderListRequestServiceDocuments}');
    debugPrint('$from - OrderRequestService => READS: ${statisticsState.orderRequestServiceRead}, WRITES: ${statisticsState.orderRequestServiceWrite}, DOCUMENTS: ${statisticsState.orderRequestServiceDocuments}');
    debugPrint('$from - OrderUpdateService => READS: ${statisticsState.orderUpdateServiceRead}, WRITES: ${statisticsState.orderUpdateServiceWrite}, DOCUMENTS: ${statisticsState.orderUpdateServiceDocuments}');
    debugPrint('$from - OrderCreateService => READS: ${statisticsState.orderCreateServiceRead}, WRITES: ${statisticsState.orderCreateServiceWrite}, DOCUMENTS: ${statisticsState.orderCreateServiceDocuments}');
    debugPrint('$from - OrderDeleteService => READS: ${statisticsState.orderDeleteServiceRead}, WRITES: ${statisticsState.orderDeleteServiceWrite}, DOCUMENTS: ${statisticsState.orderDeleteServiceDocuments}');

    debugPrint('$from - PipelineListRequestService => READS: ${statisticsState.pipelineListRequestServiceRead}, WRITES: ${statisticsState.pipelineListRequestServiceWrite}, DOCUMENTS: ${statisticsState.pipelineListRequestServiceDocuments}');
    debugPrint('$from - PipelineCreateService => READS: ${statisticsState.pipelineCreateServiceRead}, WRITES: ${statisticsState.pipelineCreateServiceWrite}, DOCUMENTS: ${statisticsState.pipelineCreateServiceDocuments}');
    debugPrint('$from - PipelineRequestService => READS: ${statisticsState.pipelineRequestServiceRead}, WRITES: ${statisticsState.pipelineRequestServiceWrite}, DOCUMENTS: ${statisticsState.pipelineRequestServiceDocuments}');
    debugPrint('$from - PipelineUpdateService => READS: ${statisticsState.pipelineUpdateServiceRead}, WRITES: ${statisticsState.pipelineUpdateServiceWrite}, DOCUMENTS: ${statisticsState.pipelineUpdateServiceDocuments}');

    debugPrint('$from - ServiceListRequestService => READS: ${statisticsState.serviceListRequestServiceRead}, WRITES: ${statisticsState.serviceListRequestServiceWrite}, DOCUMENTS: ${statisticsState.serviceListRequestServiceDocuments}');
    debugPrint('$from - ServiceListAndNavigateRequestService => READS: ${statisticsState.serviceListAndNavigateRequestServiceRead}, WRITES: ${statisticsState.serviceListAndNavigateRequestServiceWrite}, DOCUMENTS: ${statisticsState.serviceListAndNavigateRequestServiceDocuments}');
    debugPrint('$from - ServiceListAndNavigateOnConfirmRequestService => READS: ${statisticsState.serviceListAndNavigateOnConfirmRequestServiceRead}, WRITES: ${statisticsState.serviceListAndNavigateOnConfirmRequestServiceWrite}, DOCUMENTS: ${statisticsState.serviceListAndNavigateOnConfirmRequestServiceDocuments}');
    debugPrint('$from - ServiceUpdateService => READS: ${statisticsState.serviceUpdateServiceRead}, WRITES: ${statisticsState.serviceUpdateServiceWrite}, DOCUMENTS: ${statisticsState.serviceUpdateServiceDocuments}');
    debugPrint('$from - ServiceUpdateServiceVisibility => READS: ${statisticsState.serviceUpdateServiceVisibilityRead}, WRITES: ${statisticsState.serviceUpdateServiceVisibilityWrite}, DOCUMENTS: ${statisticsState.serviceUpdateServiceVisibilityDocuments}');
    debugPrint('$from - ServiceCreateService => READS: ${statisticsState.serviceCreateServiceRead}, WRITES: ${statisticsState.serviceCreateServiceWrite}, DOCUMENTS: ${statisticsState.serviceCreateServiceDocuments}');

    debugPrint('$from - StripePaymentAddPaymentMethod => READS: ${statisticsState.stripePaymentAddPaymentMethodRead}, WRITES: ${statisticsState.stripePaymentAddPaymentMethodWrite}, DOCUMENTS: ${statisticsState.stripePaymentAddPaymentMethodDocuments}');
    debugPrint('$from - StripePaymentCardListRequest => READS: ${statisticsState.stripePaymentCardListRequestRead}, WRITES: ${statisticsState.stripePaymentCardListRequestWrite}, DOCUMENTS: ${statisticsState.stripePaymentCardListRequestDocuments}');
    debugPrint('$from - StripeDetachPaymentMethodRequest => READS: ${statisticsState.stripeDetachPaymentMethodRequestRead}, WRITES: ${statisticsState.stripeDetachPaymentMethodRequestWrite}, DOCUMENTS: ${statisticsState.stripeDetachPaymentMethodRequestDocuments}');

    debugPrint('$from - UserRequestService => READS: ${statisticsState.userRequestServiceRead}, WRITES: ${statisticsState.userRequestServiceWrite}, DOCUMENTS: ${statisticsState.userRequestServiceDocuments}');
    debugPrint('$from - UserEditDevice => READS: ${statisticsState.userEditDeviceRead}, WRITES: ${statisticsState.userEditDeviceWrite}, DOCUMENTS: ${statisticsState.userEditDeviceDocuments}');
    debugPrint('$from - UserEditToken => READS: ${statisticsState.userEditTokenRead}, WRITES: ${statisticsState.userEditTokenWrite}, DOCUMENTS: ${statisticsState.userEditTokenDocuments}');
  }

}