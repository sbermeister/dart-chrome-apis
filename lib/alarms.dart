/* from alarms.idl */
part of chrome;

/**
 * Types
 */

class Alarm {
  /**
   * JS Object Representation
   */
  JSObject _jsObject;

  /**
   * Constructor
   */
  Alarm(this._jsObject);

  /**
   * Members (get only)
   */

  // Name of this alarm.
  String get name =>
      this._jsObject.baseTypeMemberVariable('name');

  // Time at which this alarm was scheduled to fire, in milliseconds past the
  // epoch (e.g. <code>Date.now() + n</code>).  For performance reasons, the
  // alarm may have been delayed an arbitrary amount beyond this.
  double get scheduledTime =>
      this._jsObject.baseTypeMemberVariable('scheduledTime');

  // If not null, the alarm is a repeating alarm and will fire again in
  // <var>periodInMinutes</var> minutes.
  double get periodInMinutes =>
      this._jsObject.baseTypeMemberVariable('periodInMinutes');
}

// TODO(mpcomplete): rename to CreateInfo when http://crbug.com/123073 is
// fixed.
class AlarmCreateInfo extends ChromeObject {
  // Time at which the alarm should fire, in milliseconds past the epoch
  // (e.g. <code>Date.now() + n</code>).
  double when;

  // Length of time in minutes after which the <code>onAlarm</code> event
  // should fire.
  //
  // <!-- TODO: need minimum=0 -->
  double delayInMinutes;

  // If set, the onAlarm event should fire every <var>periodInMinutes</var>
  // minutes after the initial event specified by <var>when</var> or
  // <var>delayInMinutes</var>.  If not set, the alarm will only fire once.
  //
  // <!-- TODO: need minimum=0 -->
  double periodInMinutes;

  /*
   * Constructor
   */
  AlarmCreateInfo({
    this.when,
    this.delayInMinutes,
    this.periodInMinutes
  });

  /*
   * Serialisation method
   */
  Map _toMap() {
    Map m = {};
    if (when != null) m['when'] = when;
    if (delayInMinutes != null) m['delayInMinutes'] = delayInMinutes;
    if (periodInMinutes != null) m['periodInMinutes'] = periodInMinutes;
    return m;
  }
}


/**
 * Events
 */

// Fired when an alarm has elapsed. Useful for event pages.
// |alarm|: The alarm that has elapsed.
class _alarms_onalarm extends __event {
  /*
   * Override callback type definitions
   */
  void addListener(void callback(Alarm alarm))
      => super.addListener(callback);
  void removeListener(void callback(Alarm alarm))
      => super.removeListener(callback);
  bool hasListener(void callback(Alarm alarm))
      => super.hasListener(callback);

  /*
   * Constructor
   */
  _alarms_onalarm() :
    super(['alarms', 'onAlarm'])
  ;
}

/**
 * Functions
 */
class _alarms {

  /*
   * API connection
   */
  ChromeApi api;

  /*
   * Events
   */
  _alarms_onalarm onAlarm;

  /*
   * Functions
   */

  // Creates an alarm.  Near the time(s) specified by <var>alarmInfo</var>,
  // the <code>onAlarm</code> event is fired. If there is another alarm with
  // the same name (or no name if none is specified), it will be cancelled and
  // replaced by this alarm.
  //
  // Note that granularity is not guaranteed: times are more of a hint to the
  // browser. For performance reasons, alarms may be delayed an arbitrary
  // amount of time before firing.
  //
  // |name|: Optional name to identify this alarm. Defaults to the empty
  // string.
  //
  // |alarmInfo|: Describes when the alarm should fire.  The initial time must
  // be specified by either <var>when</var> or <var>delayInMinutes</var> (but
  // not both).  If <var>periodInMinutes</var> is set, the alarm will repeat
  // every <var>periodInMinutes</var> minutes after the initial event.  If
  // neither <var>when</var> or <var>delayInMinutes</var> is set for a
  // repeating alarm, <var>periodInMinutes</var> is used as the default for
  // <var>delayInMinutes</var>.
  void create(AlarmCreateInfo alarmInfo, [String name]) {
    api.voidFunctionCall('create', [
        name,
        alarmInfo
    ]);
  }

  // Retrieves details about the specified alarm.
  // |name|: The name of the alarm to get. Defaults to the empty string.
  void get(void callback(Alarm alarm), [String name]) {
    api.voidFunctionCall('get', [
        name,
        callback
    ]);
  }

  // Gets an array of all the alarms.
  void getAll(void callback(List<Alarm> alarms)) {
    // proxy for void callback(List<Rule> rules)
    void __proxied_callback(var alarms) {};

    if (callback != null)
      void __proxied_callback(var alarms) {
        List<Alarm> __proxy_alarms = new List<Alarm>();

        js.scoped(() {
          for (int i = 0; i < alarms.length; i ++) {
            __proxy_alarms.add(new Alarm(alarms[i]));
          }
        });

        callback(__proxy_alarms);
      }

    api.voidFunctionCall('getAll', [
        __proxied_callback
    ]);
  }

  // Clears the alarm with the given name.
  // |name|: The name of the alarm to clear. Defaults to the empty string.
  void clear([String name]) {
    api.voidFunctionCall('clear', [
        name
    ]);
  }

  // Clears all alarms.
  void clearAll() {
    api.voidFunctionCall('clearAll');
  }

  /*
   * Constructor
   */
  _alarms() :
    api = new ChromeApi(['alarms']),
    onAlarm = new _alarms_onalarm()
    ;

}










