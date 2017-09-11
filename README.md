# NudgedHx
Haxe port of https://github.com/axelpale/nudged

**A Haxe lib** to efficiently estimate translation, scale, and/or rotation between two sets of 2D points. We have found it to be useful in **graphics, user interfaces, multi-touch recognition, and eye tracker calibration**. In general, you can apply *nudged* in any situation where you want to move a number of points based on a few sample points and optionally one fixed pivot point.

Obtain the transform from two sets of point data even if they vary in size/length.
```haxe
    import nudged.Transform;
    import nudged.Nudged;

    var domain1:Array<Float> = [125,282,109,109,252,193,237,178]; //4 points x,y,x,y,x,y,x,y
    var domain2:Array<Float> = [125,282,109,109,252,193]; //3 points x,y,x,y,x,y
    var range:Array<Float> = [102,249,108,165,239,190]; //3 points x,y,x,y,x,y

    //Get the transform between pointset domain and range.
    var transform1 = Nudged.estimateTSR(domain1, range);
    var transform2 = Nudged.estimateTSR(domain2, range);
    
    trace(transform1.getRotation(), transform2.getRotation()); //radians
    trace(transform1.getScale(), transform2.getScale());

```
