import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:petmet_app/app/home/models/appointment.dart';
import 'package:petmet_app/app/home/models/dogWalkerPackage.dart';
import 'package:petmet_app/app/home/models/groomer.dart';
import 'package:petmet_app/app/home/models/hostel.dart';
import 'package:petmet_app/app/home/models/hostelBooking.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/home/models/myDogWalkerPackage.dart';
import 'package:petmet_app/app/home/models/order.dart';
import 'package:petmet_app/app/home/models/packageTrainer.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/app/home/models/location.dart';
import 'package:petmet_app/app/home/models/promo.dart';
import 'package:petmet_app/app/home/models/trainerSubscription.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/home/models/vet.dart';
import 'package:petmet_app/app/home/models/adoption.dart';
import 'package:petmet_app/services/api_path.dart';
import 'package:petmet_app/services/firestore_service.dart';

abstract class Database {
  Stream<List<Location>> locationsStream();
  Future<void> setPet(Pet pet);
  Future<void> setAdoptPet(AdoptPet adoptPet);
  Future<void> setUserData(UserData userData, String deviceToken);
  Future<bool> checkUserData();
  Future<UserData> getUserData();
  Future<void> deletePet(Pet pet);
  Future<void> deleteAdoptPet(AdoptPet adoptPet);
  Stream<List<Pet>> petsStream();
  Stream<List<AdoptPet>> adoptPetsStream();
  Stream<List<DogWalkerPackage>> dogWalkerPackagesStream();
  Stream<List<MyDogWalkerPackage>> myDogWalkerPackagesStream();
  Future<void> setMyDogWalkerPackage(MyDogWalkerPackage package);
  Stream<List<AdoptPet>> myAdoptPetsStream();
  Stream<List<Vet>> vetsStream();
  Stream<List<Appointment>> appointmentsStream();
  Future<List<Appointment>> getAppointmentsOnThatDate(
      {@required String doctorId,
      @required String whereField,
      @required String date});
  Future<void> setAppointment(Appointment appointment);
  Future<void> sendAdoptionRequest({@required ownerId, @required petId});
  Future<void> deleteAppointment(Appointment appointment);
  Future<Vet> getVet(String doctorId);
  Future<Groomer> getGroomer(String doctorId);

  Stream<List<Item>> itemsStream(String category);
  Future<List<Item>> itemsList(String category);
  Future<DocumentSnapshot> getFilterSnapshot();

  Future<void> setCartItem(Item item, String userSelectedSize);
  Stream<List<Item>> cartStream();
  Future<void> updateCartItem(Item item, int userSelectedQuantity);
  Future<void> deleteCartItem(Item item);
  Future<void> setWishlistItem(Item item);
  Future<void> deleteWishlistItem(Item item);
  Future<bool> checkWishlist(Item item);
  Stream<List<Item>> wishlistStream();
  Stream<List> prevOrderStream();
  // Future<void> addUserPreviousOrder(Order order,String orderID);
  Future<void> updateOrder(Order order, String status, String orderId);
  Future<void> setOrder(Order order, String orderID);

  Future<void> deleteAllCartItems();
  Future<Item> getItemForHomePage(String path, String documentId);
  Future<DocumentSnapshot> getBestSellingItemsForHomePage();
  Future<DocumentSnapshot> getAquaticEssentialsForHomePage();
  Future<DocumentSnapshot> getPetGroomingForHomePage();
  Future<DocumentSnapshot> getTilesForHomePage();
  Future<DocumentSnapshot> getCategoriesForHomePage();
  Stream<List<Item>> getLimitedItemsForHomePage(
      String category, int limitLength);
  Future<DocumentSnapshot> getDeliverAddresses();
  Future<void> operationsForAParticularFieldInUserDocument(
      Map<String, dynamic> fieldObject);

  Future<List<Vet>> listOfVets(String profession, String fieldNameBool);
  Future<List<Groomer>> listOfGroomers();
  Future<List<Hostel>> listOfHostels();

  Future<List<Appointment>> listOfAppointments(String fieldName);

  Future<DocumentSnapshot> getItemsData(String category, String productId);
  Future<bool> checkPincode(int pincode);
  String getUid();
  String getEmail();
  Stream<List<Promo>> getPromos();

  Future<void> updateDeviceToken(UserData user, String deviceToken);
  Future<DocumentSnapshot> getShopCarouselImages();
  //For notifications
  Future<void> saveNotification(String message, String notificationId);
  Stream<List<Map>> notificationsStream();
  Future<void> deleteNotification(String notificationId);

  Stream<List> getItemsCategories();
  Stream<List<PackageTrainer>> getPackagesOfOnlyTrainer(String whereField);
  Future<DocumentSnapshot> getTheOnlyTrainer();
  Stream<List<TrainerSubscription>> trainerSubscriptionStream();

  Future<void> setTrainerSubscription(TrainerSubscription trainerSubscription);
  Future<void> bookHostel(HostelBooking hostelBooking);
  Stream<List<HostelBooking>> hostelBookingsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid, @required this.email})
      : assert(uid != null);
  final uid;
  final email;
  final _service = FirestoreService.instance;

  Stream<List<Location>> locationsStream() =>
      _service.collectionStream<Location>(
        path: APIPath.locations(uid),
        builder: (data, documentId) => Location.fromMap(data),
      );

  //To get list of urls for Shop Outermost page
  Future<DocumentSnapshot> getShopCarouselImages() =>
      _service.getData(path: APIPath.homePage(), documentId: "shop_carousel");

  //template Professionals
  Future<List<Vet>> listOfVets(String profession, String fieldNameBool) =>
      _service.whereCollectionList<Vet>(
        path: '/$profession',
        whereField: fieldNameBool,
        builder: (data, documentId) => Vet.fromMap(data, documentId),
      );
  Future<List<Appointment>> listOfAppointments(String fieldName) =>
      _service.whereCollectionList(
        path: APIPath.appointments(uid),
        whereField: fieldName,
        builder: (data, documentId) => Appointment.fromMap(data, documentId),
      );
  Future<List<Appointment>> getAppointmentsOnThatDate(
          {@required String doctorId,
          @required String whereField,
          @required String date}) =>
      _service.whereCollectionListWithValue(
        path: APIPath.appointments(uid),
        whereField: whereField,
        whereFieldValue: date,
        builder: (data, documentId) => Appointment.fromMap(data, documentId),
      );

  Future<List<Groomer>> listOfGroomers() => _service.collectionList(
        path: APIPath.groomers(),
        builder: (data, documentId) => Groomer.fromMap(data, documentId),
      );
  Future<List<Hostel>> listOfHostels() => _service.collectionList(
        path: APIPath.hostels(),
        builder: (data, documentId) => Hostel.fromMap(data, documentId),
      );

  //payment flow functions
  Future<void> operationsForAParticularFieldInUserDocument(
          Map<String, dynamic> fieldObject) async =>
      await _service.operationsOnAParticularField(
          path: APIPath.user(uid), fieldObject: fieldObject);
  Future<DocumentSnapshot> getDeliverAddresses() =>
      _service.getData(path: APIPath.users(), documentId: uid);

  //Home page functionality
  Stream<List> getItemsCategories() => _service.collectionStream(
        path: APIPath.itemsApp(),
        builder: (data, documentId) => {"id": documentId},
      );

  Future<DocumentSnapshot> getTheOnlyTrainer() async {
    DocumentSnapshot snapshot =
        await _service.getData(path: APIPath.trainers(), documentId: "general");
    print("Here----getting the only trainer from fb");
    return snapshot;
    // print(snapshot.data['description']);
    // return Trainer.fromMap(snapshot.data, snapshot.documentID);
  }

  Stream<List<PackageTrainer>> getPackagesOfOnlyTrainer(String whereField) =>
      _service.whereCollectionStream(
        path: APIPath.getTrainerPackages(),
        builder: (data, documentId) => PackageTrainer.fromMap(data, documentId),
        whereField: whereField,
      );

  Stream<List<TrainerSubscription>> trainerSubscriptionStream() =>
      _service.collectionStream(
        path: APIPath.subscriptions(uid),
        builder: (data, documentId) =>
            TrainerSubscription.fromMap(data, documentId),
      );

  Stream<List<HostelBooking>> hostelBookingsStream() =>
      _service.collectionStream(
        path: APIPath.hostelBookings(uid),
        builder: (data, documentId) => HostelBooking.fromMap(data, documentId),
      );

  Future<DocumentSnapshot> getItemsData(String category, String productId) =>
      _service.getData(path: APIPath.items(category), documentId: productId);

  // Future<DocumentSnapshot> getItemsCategories() => _service.getData(path: APIPath.itemsApp(),documentId: "Categories");
  Future<DocumentSnapshot> getBestSellingItemsForHomePage() => _service.getData(
      path: APIPath.homePage(), documentId: "best_selling_items");
  Future<DocumentSnapshot> getCategoriesForHomePage() =>
      _service.getData(path: APIPath.homePage(), documentId: "categories");
  Future<DocumentSnapshot> getTilesForHomePage() =>
      _service.getData(path: APIPath.homePage(), documentId: "tiles");
  Future<DocumentSnapshot> getAquaticEssentialsForHomePage() => _service
      .getData(path: APIPath.homePage(), documentId: "aquatic_essentials");
  Future<DocumentSnapshot> getPetGroomingForHomePage() =>
      _service.getData(path: APIPath.homePage(), documentId: "pet_grooming");

  Future<DocumentSnapshot> getFilterSnapshot() =>
      _service.getData(path: APIPath.homePage(), documentId: "filter");
  //Delete Items for razorpay and cart
  Future<void> deleteAllCartItems() async =>
      await _service.deleteCollection(path: APIPath.cart(uid));

  Stream<List> prevOrderStream() => _service.collectionStream(
        path: APIPath.prevOrderStream(uid),
        builder: (data, documentId) => {"data": data, "id": documentId},
      );

  Future<void> setOrder(Order order, String orderID) async =>
      await _service.setData(
        path: APIPath.particularOrder(orderID),
        data: order.toMap(),
      );

  Future<void> setTrainerSubscription(
          TrainerSubscription trainerSubscription) async =>
      await _service.setData(
        path: APIPath.subscription(uid, trainerSubscription.id),
        data: trainerSubscription.toMap(),
      );

  Future<void> updateOrder(Order order, String status, String orderId) =>
      _service.updateData(
          path: APIPath.particularOrder(orderId),
          data: order.toMap(status: status));

  // Future<void> addUserPreviousOrder(Order order,String orderID) async => await _service.setData(
  //   path: APIPath.prevOrder(uid,orderID),
  //   data: order.toMap(status: "Delivery Pending"),
  // );

  Future<Item> getItemForHomePage(String path, String documentId) async {
    final snapshot = await _service.getData(path: path, documentId: documentId);

    return Item.fromMap(snapshot.data, documentId);
  }

  Stream<List<Item>> getLimitedItemsForHomePage(
          String category, int limitLength) =>
      _service.limitedCollectionStream<Item>(
        path: APIPath.items(category),
        builder: (data, documentId) => Item.fromMap(data, documentId),
        limitLength: limitLength,
      );

  Stream<List<Vet>> vetsStream() => _service.verifiedVetsCollectionStream<Vet>(
        path: APIPath.vets(),
        builder: (data, documentId) => Vet.fromMap(data, documentId),
      );

  Stream<List<DogWalkerPackage>> dogWalkerPackagesStream() =>
      _service.collectionStream(
        path: APIPath.dogWalkerPackages(),
        builder: (data, documentId) =>
            DogWalkerPackage.fromMap(data, documentId),
      );

  Stream<List<MyDogWalkerPackage>> myDogWalkerPackagesStream() =>
      _service.collectionStream(
        path: APIPath.myDogWalkerPackages(uid),
        builder: (data, documentId) =>
            MyDogWalkerPackage.fromMap(data, documentId),
      );

  Future<void> setMyDogWalkerPackage(MyDogWalkerPackage package) async =>
      await _service.setData(
        path: APIPath.myDogWalkerPackage(uid, package.id),
        data: package.toMap(),
      );

  Stream<List<Item>> itemsStream(String category) =>
      _service.collectionStream<Item>(
        path: APIPath.items(category),
        builder: (data, documentId) => Item.fromMap(data, documentId),
      );

  Future<List<Item>> itemsList(String category) =>
      _service.collectionList<Item>(
        path: APIPath.items(category),
        builder: (data, documentId) => Item.fromMap(data, documentId),
      );

  Stream<List<Promo>> getPromos() => _service.collectionStream<Promo>(
        path: APIPath.promo(),
        builder: (data, documentId) => Promo.fromMap(data, documentId),
      );

  //Cart Functionality
  Future<void> setCartItem(Item item, String userSelectedSize) async {
    String newId=item.id.toString()+"Size="+userSelectedSize;
    await _service.setData(
      path: APIPath.cartItems(uid, newId),
      data: item.cartToMap(1, userSelectedSize: userSelectedSize),
    );
  }

  Stream<List<Item>> cartStream() => _service.collectionStream<Item>(
        path: APIPath.userCart(uid),
        builder: (data, documentId) => Item.fromMap(data, documentId),
      );

  Future<void> updateCartItem(Item item, int userSelectedQuantity) =>
      _service.updateData(
          path: APIPath.userCartItem(uid, item.id),
          data: item.cartToMap(userSelectedQuantity,
              userSelectedSize: item.userSelectedSize));

  Future<void> deleteCartItem(Item item) async =>
      await _service.deleteData(path: APIPath.userCartItem(uid, item.id));

//Wishlist Functionality
  Future<void> setWishlistItem(Item item) async => await _service.setData(
        path: APIPath.wishlistItems(uid, item.id),
        data: item.wishlistToMap(),
      );
  Stream<List<Item>> wishlistStream() => _service.collectionStream<Item>(
        path: APIPath.userWishlist(uid),
        builder: (data, documentId) => Item.fromMap(data, documentId),
      );
  Future<bool> checkWishlist(Item item) async {
    final snapshot = await _service.getData(
        path: APIPath.userWishlist(uid), documentId: item.id);
    if (snapshot.data != null) {
      print(snapshot.data);
      print('true');
      return true;
    } else {
      print('false');
      return false;
    }
  }

  Future<void> deleteWishlistItem(Item item) async =>
      await _service.deleteData(path: APIPath.userWishlistItem(uid, item.id));

  Future<void> setPet(Pet pet) async => await _service.setData(
        path: APIPath.pet(uid, pet.id),
        data: pet.toMap(),
      );

  Future<void> setAdoptPet(AdoptPet adoptPet) async {
    await _service.setData(
      path: APIPath.adoptPet(adoptPet.id),
      data: adoptPet.toMap(ownerId: uid),
    );
    await _service.setData(
      path: APIPath.myAdoptPet(uid, adoptPet.id),
      data: adoptPet.toMap(ownerId: uid),
    );
  }

  Future<void> sendAdoptionRequest({@required ownerId, @required petId}) async {
    await _service.setData(
      path: APIPath.adoptionRequest(DateTime.now().toIso8601String()),
      data: {
        'ownerId': ownerId,
        'buyerId': uid,
        'petId': petId,
      },
    );
  }

  Future<void> bookHostel(HostelBooking hostelBooking) async =>
      await _service.setData(
        path: APIPath.hostelBooking(uid, hostelBooking.id),
        data: hostelBooking.toMap(uid),
      );

  Future<void> setUserData(UserData userData, String deviceToken) async =>
      await _service.setData(
        path: APIPath.user(uid),
        data: userData.toMap(deviceToken),
      );

  Future<UserData> getUserData() async {
    final snapshot =
        await _service.getData(path: APIPath.users(), documentId: uid);
    return UserData.fromMap(snapshot.data);
  }

  Future<void> updateDeviceToken(UserData user, String deviceToken) async {
    if (user.address == null) {
      _service.updateData(
        path: APIPath.user(uid),
        data: user.sendDeviceToken(deviceToken),
      );
    } else {
      _service.updateData(
        path: APIPath.user(uid),
        data: user.toMap(deviceToken),
      );
    }
  }

  Stream<List<Pet>> petsStream() => _service.collectionStream<Pet>(
        path: APIPath.pets(uid),
        builder: (data, documentId) => Pet.fromMap(data, documentId),
      );

  Stream<List<AdoptPet>> adoptPetsStream() =>
      _service.collectionStream<AdoptPet>(
        path: APIPath.adoptPets(),
        builder: (data, documentId) => AdoptPet.fromMap(data, documentId),
      );

  Stream<List<AdoptPet>> myAdoptPetsStream() =>
      _service.collectionStream<AdoptPet>(
        path: APIPath.myAdoptPets(uid),
        builder: (data, documentId) => AdoptPet.fromMap(data, documentId),
      );
  Stream<List<Appointment>> appointmentsStream() =>
      _service.orderedCollectionStream(
        path: APIPath.appointments(uid),
        field: 'date',
        descending: true,
        builder: (data, documentId) => Appointment.fromMap(data, documentId),
      );

  Future<Vet> getVet(String doctorId) async {
    final snapshot =
        await _service.getData(path: APIPath.vets(), documentId: doctorId);
    return Vet.fromMap(snapshot.data, doctorId);
  }

  Future<Groomer> getGroomer(String doctorId) async {
    final snapshot =
        await _service.getData(path: APIPath.groomers(), documentId: doctorId);
    return Groomer.fromMap(snapshot.data, doctorId);
  }

  Future<void> deletePet(Pet pet) async =>
      await _service.deleteData(path: APIPath.pet(uid, pet.id));

  Future<void> deleteAdoptPet(AdoptPet adoptpet) async =>
      await _service.deleteData(path: APIPath.pet(uid, adoptpet.id));

  Future<void> setAppointment(Appointment appointment) async {
    await _service.setData(
        path: APIPath.appointment(uid, appointment.id),
        data: appointment.toMap(uid));
    await _service.setData(
        path: APIPath.appointmentVet(appointment.doctorId, appointment.id),
        data: appointment.toMap(uid));
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    await _service.deleteData(path: APIPath.appointment(uid, appointment.id));
  }

  Future<bool> checkPincode(int pincode) async {
    final snapshot = await _service.getData(
        path: APIPath.pincodes(), documentId: 'deliverable');
    final arr = snapshot.data['pincodes'];
    int ch = 0;
    for (int i = 0; i < arr.length; i++) {
      if (pincode == arr[i]) {
        ch = 1;
      }
    }
    if (ch == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkUserData() async {
    final snapshot =
        await _service.getData(path: APIPath.users(), documentId: uid);

    if (!snapshot.exists) {
      return false;
    }
    // final data=snapshot.data['address'];
    //
    // if(data!=null)
    // {
    //   return true;
    // }
    // else
    // {
    //   return false;
    return snapshot.data.containsKey("address");
  }

  String getUid() {
    return uid;
  }

  String getEmail() {
    return email;
  }

  Stream<List<Map>> notificationsStream() => _service.collectionStream(
      path: APIPath.notifications(uid),
      builder: (data, documentId) {
        return {
          'message': data['message'],
          'id': documentId,
        };
      });

  Future<void> saveNotification(String message, String notificationId) async =>
      _service.setData(
        path: APIPath.notification(uid, notificationId),
        data: {'message': message},
      );

  Future<void> deleteNotification(String notificationId) async =>
      _service.deleteData(path: APIPath.notification(uid, notificationId));
}

//    snapshots.listen((snapshot) { // collection snapshot
//      snapshot.documents.forEach((snapshot) => snapshot.data);// document snapshot
//    });
