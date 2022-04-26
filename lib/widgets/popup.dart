import 'package:air_quality_app/data/popup_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class PopupWidget extends StatefulWidget {
  final Marker marker;
  final int aqi;

  const PopupWidget(
    this.marker,
    this.aqi, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopupState(aqi);
}

class _PopupState extends State<PopupWidget> {
  final int _aqi;

  _PopupState(this._aqi);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        // onTap: () => null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ConstrainedBox(
              child: Center(
                  child: Text(
                _aqi.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              )),
              constraints: const BoxConstraints(
                minWidth: 50,
                maxWidth: 50,
                maxHeight: 50,
                minHeight: 50,
              ),
            ),
            _cardDescription(context),
          ],
        ),
      ),
      color: getPopupInfo(_aqi).color,
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              getPopupInfo(_aqi).description[0],
              overflow: TextOverflow.fade,
              softWrap: false,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            Text(
              getPopupInfo(_aqi).description[1],
              style:
                  const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
