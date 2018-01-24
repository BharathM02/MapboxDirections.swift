import Foundation

@objc(MBTracePoint)
public class TracePoint: Waypoint {
    
    @objc open var alternateCount: Int
    
    @objc open var waypointIndex: Int
    
    @objc open var matchingIndex: Int
    
    
    init(coordinate: CLLocationCoordinate2D, alternateCount: Int, waypointIndex: Int, matchingIndex: Int) {
        self.alternateCount = alternateCount
        self.waypointIndex = waypointIndex
        self.matchingIndex = matchingIndex
        super.init(coordinate: coordinate)
    }
    
    public required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}