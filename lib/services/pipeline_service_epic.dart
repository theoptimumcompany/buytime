import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/category/category_snippet_state.dart';
import 'package:BuyTime/reblox/model/category/category_state.dart';
import 'package:BuyTime/reblox/model/pipeline/pipeline.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_reducer.dart';
import 'package:BuyTime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/pipeline_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';


class PipelineListRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    print("PipelineListService catched action");
    return actions.whereType<RequestListPipeline>().asyncMap((event) async {

      List<Pipeline> pipelineList = List<Pipeline>();
      return Firestore.instance.collection("pipeline").getDocuments().then((QuerySnapshot snapshot) {
        print("PipelineListService firestore request");
        snapshot.docs.forEach((element) {
          Pipeline pipeline = Pipeline.fromJson(element.data());
          pipelineList.add(pipeline);
        });
        print("PipelineListService return list with " + pipelineList.length.toString());
        return new PipelineListReturned(pipelineList);
      });
    });
  }
}

class PipelineCreateService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreatePipeline>().asyncMap((event) {

    });
  }
}

class PipelineRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<PipelineRequest>().asyncMap((event) {

     /* return Firestore.instance.collection("pipeline").document(store.state.business.id_firestore).collection("category_tree").document(store.state.business.idCategoryTree).get().then((snapshot) {
        Pipeline pipeline = Pipeline(
          name: snapshot.data["name"],
          description: snapshot.data["description"],
        );
        return new PipelineRequestResponse(pipeline);
      });*/
    }).takeUntil(actions.whereType<UnlistenPipeline>());
  }
}

class PipelineUpdateService implements EpicClass<AppState> {

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdatePipeline>().asyncMap((event) {

   /*   return Firestore.instance
          .collection("business")
          .document(store.state.business.id_firestore)
          .collection("category_tree")
          .document(store.state.business.idCategoryTree)
          .updateData(.toJson())
          .then((value) {
        print("Pipeline Service should be updated online ");
        return new UpdatedPipeline(null);
      });*/
    }).takeUntil(actions.whereType<UnlistenPipeline>());
  }
}
