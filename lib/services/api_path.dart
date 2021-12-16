class APIPath {
  static String pet(String uid, String petId) => '/user/$uid/pets/$petId';
  static String adoptPet(String adoptPetId) => '/adoptPets/$adoptPetId';
  static String myAdoptPet(String uid, String adoptPetId) => '/user/$uid/adoptPets/$adoptPetId';
  static String user(String uid) => '/user/$uid';
  static String users() => '/user';
  static String locations(String uid) => 'locations';
  static String pets(String uid) => '/user/$uid/pets';
  static String adoptPets() => '/adoptPets';
  static String adoptionRequest(String requestId) => '/adoptionRequests/$requestId';
  static String myAdoptPets(String uid) => '/user/$uid/adoptPets';
  static String vets() => '/vet';
  static String appointment(String uid, String appointmentId) => '/user/$uid/appointments/$appointmentId';
  static String appointmentVet(String uidVet, String appointmentId) => '/vet/$uidVet/appointments/$appointmentId';
  static String appointments(String uid) => '/user/$uid/appointments';
  static String items(String category) => '/items/$category/products';

  static String cartItems(String uid, String itemUID) => '/user/$uid/cartApp/$itemUID';
  static String userCart(String uid) => '/user/$uid/cartApp';
  static String userCartItem(String uid, String itemId) => '/user/$uid/cartApp/$itemId';

  static String wishlistItems(String uid, String itemUID) => '/user/$uid/wishlistApp/$itemUID';
  static String userWishlist(String uid) => '/user/$uid/wishlistApp';
  static String userWishlistItem(String uid, String itemId) => '/user/$uid/wishlistApp/$itemId';
  static String itemsApp() => '/items';
  static String pincodes() => '/pincode';
  static String homePage() => '/homepage';
  // static String particularItem(String category,String productID)=>'/items/$category/products/$productID';

  static String prevOrderStream(String uid) => '/user/$uid/orders';
  static String cart(String uid) => '/user/$uid/cartApp';
  // static String prevOrder(String uid,String orderID)=>'/user/$uid/prevOrdersApp/$orderID';

  static String particularOrder(String orderId) => '/orders_app/$orderId';

  static String vetsApp() => '/vetsApp';

  static String promo() => '/promo';
  static String notification(String uid, String notificationId) => '/user/$uid/notifications/$notificationId';
  static String notifications(String uid) => '/user/$uid/notifications';

  static String groomers() => '/groomers';
  static String hostels() => '/hostels';

  static String trainers() => '/trainers';
  static String getTrainerPackages() => '/trainerPackages';
  static String subscriptions(String uid) => '/user/$uid/subscriptions';
  static String subscription(String uid, String subscriptionId) => '/user/$uid/subscriptions/$subscriptionId';

  static String dogWalkerPackages() => '/dogWalkerPackages';
  static String myDogWalkerPackages(String uid) => '/user/$uid/myDogWalkerPackages';
  static String myDogWalkerPackage(String uid, String packageId) => '/user/$uid/myDogWalkerPackages/$packageId';
  static String hostelBooking(String uid, String bookingId) => '/user/$uid/hostelBookings/$bookingId';
  static String hostelBookings(String uid) => '/user/$uid/hostelBookings';
}
