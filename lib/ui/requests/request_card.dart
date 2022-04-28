import 'package:flutter/material.dart';
import 'package:request_live/ui/requests/request_detail_screen.dart';

import '../../models/request.dart';
import '../../routes.dart';
import '../../resources/conversions.dart';
import '../entertainer/entertainer_screen.dart';

class RequestCard extends StatefulWidget {
  final requestId;
  final snap;

  const RequestCard({
    Key? key,
    required this.requestId,
    required this.snap,
  }) : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  late String userImageUrl = widget.snap['photo_url'].toString();
  late Request request = Request(
    uid: widget.requestId,
    artist: widget.snap["artist"],
    title: widget.snap["title"],
    notes: widget.snap["notes"],
    requesterId: widget.snap["requester_id"],
    requesterUsername: widget.snap['requester_username'],
    requesterPhotoUrl: widget.snap['requester_photo_url'],
    entertainerId: widget.snap["entertainer_id"],
    played: widget.snap["played"],
    timestamp: widget.snap["timestamp"],
  );
  // late DateTime requestDateTime = (widget.snap['timestamp']).toDate();
  // late String stockPhotoUrl = 'request-live-4864a.appspot.com/user.png';
  late String stockPhotoUrl = 'https://i.stack.imgur.com/l60Hf.png';
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Do not display current user's EntertainerCard
    return GestureDetector(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(
                  widget.snap['requester_photo_url'],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        // RequestRow(
                        //   username: widget.snap['requester_username'].toString(),
                        //   artist: widget.snap['artist'].toString(),
                        //   title: widget.snap['title'].toString(),
                        //   notes: widget.snap['notes'].toString(),
                        //   time: Conversions.convertTimeStamp(
                        //       widget.snap['timestamp']),
                        // ),
                        RequestRowOld(
                            section: 'User:   ',
                            details:
                                widget.snap['requester_username'].toString()),
                        RequestRowOld(
                            section: 'Artist: ',
                            details: widget.snap['artist'].toString()),
                        RequestRowOld(
                            section: 'Title:   ',
                            details: widget.snap['title'].toString()),
                        RequestRowOld(
                            section: 'Notes: ',
                            details: widget.snap['notes'].toString()),
                        RequestRowOld(
                            section: 'Time:  ',
                            details: Conversions.convertTimeStamp(
                                widget.snap['timestamp'])),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Navigate to entertainer's page!
      onTap: () {
        // TODO Navigate to request detail page
        Navigator.pushNamed(
          context,
          Routes.requestDetail,
          arguments: RequestDetailScreenArgs(
            request,
          ),
        );
      },
    );
  }
}

class RequestRowOld extends StatelessWidget {
  final String section;
  final String details;

  const RequestRowOld({
    Key? key,
    required this.section,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Text(
              section,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Text(
              details,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RequestRow extends StatelessWidget {
  final String username;
  final String artist;
  final String title;
  final String notes;
  final String time;

  const RequestRow({
    Key? key,
    required this.username,
    required this.artist,
    required this.title,
    required this.notes,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'User: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Artist: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Title: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Notes: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Time: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  username,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  artist,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  notes,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  time,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
