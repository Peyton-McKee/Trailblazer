//
//  TrailsDatabase.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/26/22.
//

import Foundation
import MapKit


enum Difficulty
{
    case easy
    case intermediate
    case advanced
    case expertsOnly
    case lift
    case terrainPark
}

enum userStatus
{
    case guest
    case member
}


class ImageAnnotation : NSObject, MKAnnotation{
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        var colour: UIColor?
        var difficulty: Difficulty?
        var trailReport : TrailReportType?
        var image: UIImage?
        
        override init() {
            self.coordinate = CLLocationCoordinate2D()
            self.title = nil
            self.subtitle = nil
            self.difficulty = nil
            self.trailReport = nil
            self.image = nil
            self.colour = UIColor.white
        }
}
class ImageAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        canShowCallout = true
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupUI() {
        backgroundColor = .clear
        let view = UIView(frame: .zero)
        addSubview(view)
        
        view.frame = bounds
    }
}


class TrailsDatabase : NSObject {
    
    static let CommonlyJunctionedTrailNames = ["Tin Woodsman", "Vortex", "Northern Lights", "Airglow", "Dream Maker", "Grand Rapids"]

    static let Lifts =
    [Lift(name: "Jordan", annotations: [createAnnotation(title: "JordanBot", latitude: 44.4717323221508, longitude: -70.89489548889809, difficulty: .lift), createAnnotation(title: "JordanTop", latitude: 44.46239249702886, longitude: -70.90754291060291, difficulty: .lift)]),

     Lift(name: "Aurora", annotations: [createAnnotation(title: "AuroraBot", latitude: 44.471807197499686, longitude: -70.88638321700229, difficulty: .lift), createAnnotation(title: "topAurora", latitude: 44.46308843335746, longitude: -70.88975714956065, difficulty: .lift)]),

     Lift(name: "Jordan Double", annotations: [createAnnotation(title: "auroraSideJD", latitude: 44.47185220242018, longitude: -70.8868831674901, difficulty: .lift), createAnnotation(title: "jordSideJD", latitude: 44.471727779664356, longitude: -70.89391070242685, difficulty: .lift)]),
     
     Lift(name: "Southridge Chondola", annotations: [createAnnotation(title: "chondBot", latitude: 44.473098413827294, longitude: -70.85745769220948, difficulty: .lift), createAnnotation(title: "chondTop", latitude: 44.468643133308056, longitude: -70.87985424949272, difficulty: .lift)]),
    
     Lift(name: "North Peak Express", annotations: [createAnnotation(title: "botNP", latitude: 44.47392442992593, longitude: -70.86496661448741, difficulty: .lift), createAnnotation(title: "topNP", latitude: 44.47016716972932, longitude: -70.87984653186034, difficulty: .lift)]),
    
     Lift(name: "Quantum Leap Triple", annotations: [createAnnotation(title: "botQLT", latitude: 44.47135602096759, longitude: -70.88539833730681, difficulty: .lift), createAnnotation(title: "topQLT", latitude: 44.469956233389304, longitude: -70.88004779413315, difficulty: .lift)]),
    
     Lift(name: "Spruce Triple", annotations: [createAnnotation(title: "botSpruce", latitude: 44.46956649226089, longitude: -70.86889775439303, difficulty: .lift), createAnnotation(title: "topSpruce", latitude: 44.463183391461904, longitude: -70.88237835188288, difficulty: .lift)]),
    Lift(name: "Southridge Express", annotations: []),
    Lift(name: "Barker Express", annotations: []),
    Lift(name: "Locke Triple", annotations: []),
    Lift(name: "Tempest Quad", annotations: []),
    Lift(name: "Little White Cap Quad", annotations: []),
    Lift(name: "White Heat Quad", annotations: [])]
    
    static let barkerTrails : [Trail] = [
        Trail(name: "Three Mile Trail", difficulty: "Easy", annotations: []),
        Trail(name: "Lazy River", difficulty: "Intermediate", annotations: []),
        Trail(name: "Sluice", difficulty: "Intermediate", annotations: []),
        Trail(name: "Right Stuff", difficulty: "Advanced", annotations: []),
        Trail(name: "Agony", difficulty: "Expert's Only", annotations: []),
        Trail(name: "Hollywood", difficulty: "Expert's Only", annotations: []),
        Trail(name: "Top Gun", difficulty: "Expert's Only", annotations: []),
        Trail(name: "Ecstasy", difficulty: "Intermediate", annotations: []),
        Trail(name: "Jungle Road", difficulty: "Intermediate", annotations: []),
        Trail(name: "Lower Upper Cut", difficulty: "Intermediate", annotations: []),
        Trail(name: "Southpaw", difficulty: "Intermediate", annotations: []),
        Trail(name: "Sunday Punch", difficulty: "Intermediate", annotations: []),
        Trail(name: "Rocking Chair", difficulty: "Intermediate", annotations: []),
        Trail(name: "Flow State", difficulty: "Terrain Park", annotations: []),
        Trail(name: "Tightwire", difficulty: "Advanced", annotations: [])]
    
    static let southRidgeTrails : [Trail] = [
        Trail(name: "Ridge Run", difficulty: "Easy", annotations: []),
        Trail(name: "Lower Escapade", difficulty: "Easy", annotations: []),
        Trail(name: "Broadway", difficulty: "Easy", annotations: []),
        Trail(name: "Lower Lazy River", difficulty: "Easy", annotations: []),
        Trail(name: "Thataway", difficulty: "Easy", annotations: []),
        Trail(name: "Mixing Bowl", difficulty: "Easy", annotations: []),
        Trail(name: "Lower Chondi Line", difficulty: "Easy", annotations: []),
        Trail(name: "WhoVille", difficulty: "Terrain Park", annotations: []),
        Trail(name: "Wonderland", difficulty: "Terrain Park", annotations: []),
        Trail(name: "Northway", difficulty: "Easy", annotations: []),
        Trail(name: "Spectator", difficulty: "Easy", annotations: []),
        Trail(name: "Double Dipper", difficulty: "Easy", annotations: []),
        Trail(name: "Sundance", difficulty: "Easy", annotations: []),
        Trail(name: "Second Thoughts", difficulty: "Easy", annotations: []),
        Trail(name: "Ridge Express", difficulty: "Easy", annotations: []),
        Trail(name: "Exit Right", difficulty: "Easy", annotations: [])]
    
    static let lockeTrails  : [Trail] = [
        Trail(name: "Goat Path", difficulty: "Intermediate", annotations: []),
        Trail(name: "Upper Cut", difficulty: "Advanced", annotations: []),
        Trail(name: "Upper Sunday Punch", difficulty: "Intermedaite", annotations: []),
        Trail(name: "Locke Line", difficulty: "Advanced", annotations: []),
        Trail(name: "Jim's Whim", difficulty: "Advanced", annotations: []),
        Trail(name: "T2", difficulty: "Advanced", annotations: []),
        Trail(name: "Bim's Whim", difficulty: "Advanced", annotations: []),
        Trail(name: "Cascades", difficulty: "Intermediate", annotations: []),
        Trail(name: "Monday Morning", difficulty: "Advanced", annotations: []),
        Trail(name: "Bear Paw", difficulty: "Easy", annotations: []),
        Trail(name: "WildFire", difficulty: "Intermediate", annotations: []),
        Trail(name: "RoadRunner", difficulty: "Easy", annotations: []),
        Trail(name: "Snowbound", difficulty: "Advanced", annotations: [])]
    
    static let whiteCapTrails : [Trail] = [
        Trail(name: "Salvation", difficulty: "Intermediate", annotations: []),
        Trail(name: "Heat's Off", difficulty: "Intermediate", annotations: []),
        Trail(name: "Obsession", difficulty: "Advanced", annotations: []),
        Trail(name: "Chutzpah", difficulty: "Expert's Only", annotations: []),
        Trail(name: "White Heat", difficulty: "Expert's Only", annotations: []),
        Trail(name: "Shock Wave", difficulty: "Expert's Only", annotations: []),
        Trail(name: "Tempest", difficulty: "Advanced", annotations: []),
        Trail(name: "Jibe", difficulty: "Intermediate", annotations: []),
        Trail(name: "Heat's On", difficulty: "Intermediate", annotations: []),
        Trail(name: "Green Cheese", difficulty: "Easy", annotations: []),
        Trail(name: "Moonstruck", difficulty: "Easy", annotations: []),
        Trail(name: "Assumption", difficulty: "Intermediate", annotations: []),
        Trail(name: "Starlight", difficulty: "Easy", annotations: []),
        Trail(name: "Starstruck", difficulty: "Advanced", annotations: []),
        Trail(name: "Starwood", difficulty: "Advanced", annotations: []),
        Trail(name: "Starburst", difficulty: "Intermediate", annotations: [])]
    
    static let spruceTrails : [Trail] = [
        Trail(name: "Sirius", difficulty: "Easy", annotations: []),
        Trail(name: "Upper Downdraft", difficulty: "Advanced", annotations: []),
        Trail(name: "American Express", difficulty: "Intermediate", annotations: []),
        Trail(name: "Risky Business", difficulty: "Intermediate", annotations: []),
        Trail(name: "Gnarnia", difficulty: "Expert's Only", annotations: [])]

    static let jordanTrails = [
        Trail(name: "Lollapalooza", difficulty: "Easy", annotations: [createAnnotation(title: "TopLolla", latitude: 44.462722133198504, longitude: -70.90801346676562, difficulty: .easy), createAnnotation(title: "Bend1Lolla", latitude: 44.46896537000713, longitude: -70.91051231074235, difficulty: .easy), createAnnotation(title: "Bend2Lolla", latitude: 44.47320361662942, longitude: -70.90307864281174, difficulty: .easy)]),
//1
        Trail(name: "Excalibur", difficulty: "Intermediate", annotations: [createAnnotation(title: "topExcal", latitude: 44.4631862777165, longitude: -70.9075832927418, difficulty: .intermediate), createAnnotation(title: "bend1Excal", latitude: 44.46617465583206, longitude: -70.90667308737615, difficulty: .intermediate), createAnnotation(title: "midExcal", latitude: 44.46862888873153, longitude: -70.90326718886139, difficulty: .intermediate), createAnnotation(title: "botExcal", latitude: 44.47189010004125, longitude: -70.89631064496007, difficulty: .intermediate)]),
//2
        Trail(name: "Rogue Angel", difficulty: "Intermediate", annotations: [createAnnotation(title: "TopRogue", latitude: 44.46239298417106, longitude: -70.90692334506952, difficulty: .intermediate), createAnnotation(title: "MidRogue", latitude: 44.46633955610793, longitude: -70.90488744187293, difficulty: .intermediate), createAnnotation(title: "BotRogue", latitude: 44.470166735232745, longitude: -70.89713414576988, difficulty: .intermediate)]),
//3
        Trail(name: "iCaramba!", difficulty: "Experts Only", annotations: [createAnnotation(title: "topCaram", latitude: 44.463279337031715, longitude: -70.90610218702001, difficulty: .expertsOnly), createAnnotation(title: "botCaram", latitude: 44.46845226794425, longitude: -70.89911260345167, difficulty: .expertsOnly)]),
//4
        Trail(name: "Kansas", difficulty: "Easy", annotations: [createAnnotation(title: "topKans", latitude: 44.46217702622463, longitude: -70.90716492905683, difficulty: .easy), createAnnotation(title: "bend1Kans", latitude: 44.4616778233863, longitude: -70.90722336991544, difficulty: .easy), createAnnotation(title: "ozJunctionKans", latitude: 44.46123534688093, longitude: -70.904483474769, difficulty: .easy), createAnnotation(title: "woodsmanJunctionKans", latitude: 44.460493480812396, longitude: -70.90366928411956, difficulty: .easy), createAnnotation(title: "bend2Kans", latitude: 44.460163849745214, longitude: -70.90148578576282, difficulty: .easy), createAnnotation(title: "bend3Kans", latitude: 44.46120348032429, longitude: -70.89721818116446, difficulty: .easy), createAnnotation(title: "bend4Kans", latitude: 44.461197797114906, longitude: -70.89514601904098, difficulty: .easy), createAnnotation(title: "endKans", latitude: 44.46460234637316, longitude: -70.89052023312101, difficulty: .easy)])]


    static let OzTrails : [Trail] = [
        Trail(name: "Tin Woodsman", difficulty: "Expert Only", annotations: [createAnnotation(title: "topWoodsman", latitude: 44.46000309303237, longitude: -70.90520452974141, difficulty: .expertsOnly), createAnnotation(title: "junctionWoodsman", latitude: 44.460493480812396, longitude: -70.90366928411956, difficulty: .expertsOnly), createAnnotation(title: "endWoodsman", latitude: 44.46555178523853, longitude: -70.89955012783363, difficulty: .expertsOnly)])]
    
    static let AuroraTrails = [
        Trail(name: "Cyclone", difficulty: "Easy", annotations: [createAnnotation(title: "topCyclone", latitude: 44.46456443017323, longitude: -70.88952523556077, difficulty: .easy), createAnnotation(title: "NorthernLightsJunctionCyclone", latitude: 44.46558362151272, longitude: -70.89119954539368, difficulty: .easy), createAnnotation(title: "PoppyFieldsJunctionCyclone", latitude: 44.465180155636666, longitude: -70.89860031454471, difficulty: .easy), createAnnotation(title: "WoodsmanJunctionCyclone", latitude: 44.46618881509814, longitude: -70.89898577127133, difficulty: .easy), createAnnotation(title: "CarambaJunctionCyclone", latitude: 44.468756233263775, longitude: -70.89862601165983, difficulty: .easy), createAnnotation(title: "RogueAngelJunctionCyclone", latitude: 44.47025995431891, longitude: -70.89703279052316, difficulty: .easy)]),
//7
        Trail(name: "Northern Lights", difficulty: "Intermediate", annotations: [createAnnotation(title: "topNL", latitude: 44.463074702413536, longitude: -70.89016787184919, difficulty: .intermediate), createAnnotation(title: "witchWayNLJunction", latitude: 44.463381905172064, longitude: -70.89103146842714, difficulty: .intermediate), createAnnotation(title: "KansasNLJunction", latitude: 44.464494386806685, longitude: -70.89016611861871, difficulty: .intermediate), createAnnotation(title: "cycloneJunctionNL", latitude: 44.46558362151272, longitude: -70.89119954539368, difficulty: .intermediate), createAnnotation(title: "Bend1NL", latitude: 44.46833930957292, longitude: -70.89052310618935, difficulty: .intermediate), createAnnotation(title: "fireStarJunction", latitude: 44.47011932648898, longitude: -70.88898936523161, difficulty: .intermediate)]),
//8
        Trail(name: "Witch Way", difficulty: "Intermediate", annotations: [createAnnotation(title: "topWitch", latitude: 44.46331003750903, longitude: -70.89121983761352, difficulty: .intermediate), createAnnotation(title: "kansJunctionWitchWay", latitude: 44.463261798949524, longitude: -70.89272761114972, difficulty: .easy)]),
//9
        Trail(name: "Airglow", difficulty: "Advanced", annotations: [createAnnotation(title: "topAirglow", latitude: 44.46295555779937, longitude: -70.88985528788332, difficulty: .advanced), createAnnotation(title: "cycloneJunctionAirglow", latitude: 44.46455484997939, longitude: -70.88938730025085, difficulty: .advanced), createAnnotation(title: "bend1Airglow", latitude: 44.46662949056471, longitude: -70.889916758492, difficulty: .advanced), createAnnotation(title: "blackHoleJunctionAirglow", latitude: 44.46796659263303, longitude: -70.88877674135661, difficulty: .advanced), createAnnotation(title: "bend2Airglow", latitude: 44.468647480083405, longitude: -70.88886118943041, difficulty: .advanced), createAnnotation(title: "botAirglow", latitude: 44.470649076580095, longitude: -70.88638637103126, difficulty: .advanced)]),
//10
        Trail(name: "Black Hole", difficulty: "Experts Only", annotations: [createAnnotation(title: "topBlackHole", latitude: 44.46807563954452, longitude: -70.88849119199799, difficulty: .expertsOnly), createAnnotation(title: "botBlackHole", latitude: 44.468389612889254, longitude: -70.88751782797863, difficulty: .expertsOnly)]),
//11
        Trail(name: "Fire Star", difficulty: "Intermediate", annotations: [createAnnotation(title: "topFirestar", latitude: 44.47027546367753, longitude: -70.8891562617633, difficulty: .intermediate), createAnnotation(title: "bend1Firestar", latitude: 44.47131672230162, longitude: -70.88964243473075, difficulty: .intermediate), createAnnotation(title: "bend2Firestar", latitude: 44.47067522787059, longitude: -70.89290882164136, difficulty: .intermediate), createAnnotation(title: "endFirestar", latitude: 44.47144966604338, longitude: -70.89408874939902, difficulty: .intermediate)]),
//12
        Trail(name: "Lights Out", difficulty: "Easy", annotations: [createAnnotation(title: "startLO", latitude: 44.46462524594242, longitude: -70.88910826784524, difficulty: .easy), createAnnotation(title: "vortexJunctionLO", latitude: 44.465846797045174, longitude: -70.88490523498776, difficulty: .easy), createAnnotation(title: "UpperDownDraftJunction", latitude: 44.466777506067146, longitude: -70.88153876394715, difficulty: .easy), createAnnotation(title: "endLightsOut", latitude: 44.46805596442271, longitude: -70.87977953790342, difficulty: .easy)]),
//14
        Trail(name: "Borealis", difficulty: "Easy", annotations: [createAnnotation(title: "topBorealis", latitude: 44.46278170427937, longitude: -70.8895517763241, difficulty: .easy), createAnnotation(title: "bend1Borealis", latitude: 44.46248534478416, longitude: -70.88749443819064, difficulty: .easy), createAnnotation(title: "bend2Borealis", latitude: 44.4632449499215, longitude: -70.88551136371929, difficulty: .easy), createAnnotation(title: "vertexJunctionBorealis", latitude: 44.463909310290184, longitude: -70.88505530436773, difficulty: .easy), createAnnotation(title: "bend3Borealis", latitude: 44.46363692988425, longitude: -70.88602217785332, difficulty: .easy), createAnnotation(title: "endBorealis", latitude: 44.46456958036436, longitude: -70.88903941153798, difficulty: .easy)]),
//15
            Trail(name: "Vortex", difficulty: "Experts Only", annotations: [createAnnotation(title: "topVortex", latitude: 44.464086260411534, longitude: -70.88472455446858, difficulty: .expertsOnly), createAnnotation(title: "KansasJunctionVortex", latitude: 44.465875965885864, longitude: -70.88498076829377, difficulty: .expertsOnly), createAnnotation(title: "botVertex", latitude: 44.468935280601265, longitude: -70.88537258035753, difficulty: .expertsOnly)])]
    
    static let NorthPeakTrails = [
//13
        Trail(name: "Paradigm", difficulty: "Intermediate", annotations: [createAnnotation(title: "topParadigm", latitude: 44.46924157923843, longitude: -70.88073865336285, difficulty: .intermediate), createAnnotation(title: "bend1Paradigm", latitude: 44.4684834073092, longitude: -70.88413019219388, difficulty: .intermediate), createAnnotation(title: "vertexJunctionParadigm", latitude: 44.469151693786706, longitude: -70.88538404261011, difficulty: .intermediate), createAnnotation(title: "botParadigm", latitude: 44.4704364585831, longitude: -70.88622009554196, difficulty: .intermediate)]),
//16
        Trail(name: "Second Mile", difficulty: "Easy", annotations: [createAnnotation(title: "startSM", latitude: 44.46943702535925, longitude: -70.8789654647034, difficulty: .easy), createAnnotation(title: "grandRapidsJunctionSM", latitude: 44.47032406589279, longitude: -70.8781603365251, difficulty: .easy), createAnnotation(title: "DMTerrainJunctionSM", latitude: 44.47088989413925, longitude: -70.87745792932414, difficulty: .easy), createAnnotation(title: "escapadeJunctionSM", latitude: 44.471003653600654, longitude: -70.87608625181753, difficulty: .easy), createAnnotation(title: "3DJunctionSM", latitude: 44.47182260784928, longitude: -70.87552946703043, difficulty: .easy), createAnnotation(title: "T72Junction", latitude: 44.47240398079546, longitude: -70.87625359900291, difficulty: .easy), createAnnotation(title: "DMJunctionSM", latitude: 44.472801490123636, longitude: -70.87674741037038, difficulty: .easy), createAnnotation(title: "endSM", latitude: 44.473345284763425, longitude: -70.87706137962822, difficulty: .easy)]),
//17
        Trail(name: "Quantum Leap", difficulty: "Experts Only", annotations: [createAnnotation(title: "topQuantum", latitude: 44.47035064728613, longitude: -70.88015704719764, difficulty: .expertsOnly), createAnnotation(title: "backsideJunctionQL", latitude: 44.47122504001555, longitude: -70.88101932258316, difficulty: .expertsOnly), createAnnotation(title: "bend1QL", latitude: 44.47168976730243, longitude: -70.8815677621026, difficulty: .expertsOnly), createAnnotation(title: "botQuantum", latitude: 44.47158096623986, longitude: -70.8846825390319, difficulty: .expertsOnly)]),
//18
        Trail(name: "Grand Rapids", difficulty: "Intermediate", annotations: [createAnnotation(title: "topGR", latitude: 44.469956233389304, longitude: -70.88004779413315, difficulty: .intermediate), createAnnotation(title: "SMJunctionGR", latitude: 44.47031418756157, longitude: -70.87814112970221, difficulty: .intermediate), createAnnotation(title: "bend1GR", latitude: 44.46985270909712, longitude: -70.87704051030686, difficulty: .intermediate), createAnnotation(title: "downdraftJunctionGR", latitude: 44.47013967347965, longitude: -70.8751210217859, difficulty: .intermediate), createAnnotation(title: "bend2GR", latitude: 44.46988573312703, longitude: -70.87342068410626, difficulty: .intermediate), createAnnotation(title: "bend3GR", latitude: 44.470165629165166, longitude: -70.87145465636517, difficulty: .intermediate), createAnnotation(title: "lazyRiverJunction", latitude: 44.46994988535315, longitude: -70.87066371925623, difficulty: .intermediate), createAnnotation(title: "endGR", latitude: 44.469782541751115, longitude: -70.86966881640289, difficulty: .intermediate)]),
//19
        Trail(name: "Lower Downdraft", difficulty: "Intermediate", annotations: [createAnnotation(title: "topLD", latitude: 44.46860992943861, longitude: -70.87879804629708, difficulty: .intermediate), createAnnotation(title: "GRJunctionLD", latitude: 44.46959736320973, longitude: -70.87530580117387, difficulty: .intermediate), createAnnotation(title: "AEJunctionLD", latitude: 44.46918178597036, longitude: -70.874023955678, difficulty: .intermediate)]),
//20
        Trail(name: "Dream Maker", difficulty: "Easy", annotations: [createAnnotation(title: "topDM", latitude: 44.47041324409543, longitude: -70.87983797942842, difficulty: .easy), createAnnotation(title: "bend1DM", latitude: 44.47115946746551, longitude: -70.87910663287175, difficulty: .easy), createAnnotation(title: "TPJunctionDM", latitude: 44.47116183566172, longitude: -70.87818807321169, difficulty: .easy), createAnnotation(title: "SMJunctionDM", latitude: 44.47266041086979, longitude: -70.87677881029504, difficulty: .easy), createAnnotation(title: "Bend2DM", latitude: 44.47420077369788, longitude: -70.87533495049598, difficulty: .easy), createAnnotation(title: "Bend3DM", latitude: 44.47533196146996, longitude: -70.87194777471294, difficulty: .easy), createAnnotation(title: "RRJunctionDM", latitude: 44.47537671715984, longitude: -70.87087950264689, difficulty: .easy), createAnnotation(title: "bend4DM", latitude: 44.475244640416406, longitude: -70.86821222409266, difficulty: .easy)]),
//21
        Trail(name: "T72", difficulty: "Intermediate", annotations: [createAnnotation(title: "topT72", latitude: 44.472471107753584, longitude: -70.87620738098036, difficulty: .intermediate), createAnnotation(title: "lastMileJunctionT72", latitude: 44.47337872106561, longitude: -70.87490427324434, difficulty: .intermediate), createAnnotation(title: "RRJunctionT72", latitude: 44.47453803470397, longitude: -70.87116281597753, difficulty: .intermediate), createAnnotation(title: "endT72", latitude: 44.47473408882887, longitude: -70.86794362038924, difficulty: .intermediate)]),
//22
        Trail(name: "Sensation", difficulty: "Easy", annotations: [createAnnotation(title: "topSensation", latitude: 44.47357411061319, longitude: -70.87714633484791, difficulty: .easy), createAnnotation(title: "bend1Sensation", latitude: 44.47383611957847, longitude: -70.87866777885614, difficulty: .easy), createAnnotation(title: "bend2Sensation", latitude: 44.473345120391464, longitude: -70.88219792471021, difficulty: .easy), createAnnotation(title: "bend3Sensation", latitude: 44.47295085342931, longitude: -70.88307854077962, difficulty: .easy), createAnnotation(title: "QLJunctionSensation", latitude: 44.47142563657733, longitude: -70.88504385707459, difficulty: .easy)]),
//23
        Trail(name: "Dream Maker Terrain Park", difficulty: "Intermediate", annotations: [createAnnotation(title: "topDMTP", latitude: 44.471098472385926, longitude: -70.87821486957192, difficulty: .intermediate), createAnnotation(title: "botDMTP", latitude: 44.47093461371656, longitude: -70.87731104843927, difficulty: .easy)]),
//24
        Trail(name: "Escapade", difficulty: "Intermediate", annotations: [createAnnotation(title: "topEscapade", latitude: 44.470882935117665, longitude: -70.87588241388997, difficulty: .intermediate), createAnnotation(title: "bend1Escapade", latitude: 44.47042148619526, longitude: -70.87252464845587, difficulty: .intermediate), createAnnotation(title: "LMJunctionEscapade", latitude: 44.47141532781848, longitude: 70.87013850162772, difficulty: .intermediate)]),
//25
        Trail(name: "3D", difficulty: "Intermediate", annotations: [createAnnotation(title: "top3D", latitude: 44.47198060772869, longitude: -70.87525217806382, difficulty: .intermediate), createAnnotation(title: "LMJunction3D", latitude: 44.47277555409285, longitude: -70.87325638692266, difficulty: .intermediate), createAnnotation(title: "RRJunction3D", latitude: 44.47357813833369, longitude: -70.87069873813503, difficulty: .intermediate), createAnnotation(title: "bend13D", latitude: 44.47391397246592, longitude: -70.86865469996928, difficulty: .intermediate), createAnnotation(title: "bot3D", latitude: 44.474622082181334, longitude: -70.86708734917693, difficulty: .intermediate)])]
    
//Spruce
    static let botSpruce = Vertex<ImageAnnotation>(Lifts[6].annotations[0])
    static let topSpruce = Vertex<ImageAnnotation>(Lifts[6].annotations[1])
//QLT
    static let botQLT = Vertex<ImageAnnotation>(Lifts[5].annotations[0])
    static let topQLT = Vertex<ImageAnnotation>(Lifts[5].annotations[1])
//North peak
    static let botNP = Vertex<ImageAnnotation>(Lifts[4].annotations[0])
    static let topNP = Vertex<ImageAnnotation>(Lifts[4].annotations[1])
//chondola
    static let botChondola = Vertex<ImageAnnotation>(Lifts[3].annotations[0])
    static let topChondola = Vertex<ImageAnnotation>(Lifts[3].annotations[1])
//Jordan DOuble
    static let auroraSideJD = Vertex<ImageAnnotation>(Lifts[2].annotations[0])
    static let jordanSideJD = Vertex<ImageAnnotation>(Lifts[2].annotations[1])
//aurora
    static let botAurora = Vertex<ImageAnnotation>(Lifts[1].annotations[0])
    static let topAurora = Vertex<ImageAnnotation>(Lifts[1].annotations[1])
//jordan
    static let topJord = Vertex<ImageAnnotation>(Lifts[0].annotations[1])
    static let botJord = Vertex<ImageAnnotation>(Lifts[0].annotations[0])
//lolapalooza
    static let topLol = Vertex<ImageAnnotation>(jordanTrails[0].annotations[0])
    static let bend1Lol = Vertex<ImageAnnotation>(jordanTrails[0].annotations[1])
    static let bend2Lol = Vertex<ImageAnnotation>(jordanTrails[0].annotations[2])
//excalibur
    static let topExcal = Vertex<ImageAnnotation>(jordanTrails[1].annotations[0])
    static let bend1Excal = Vertex<ImageAnnotation>(jordanTrails[1].annotations[1])
    static let midExcal = Vertex<ImageAnnotation>(jordanTrails[1].annotations[2])
    static let botExcal = Vertex<ImageAnnotation>(jordanTrails[1].annotations[3])
//rogueangel
    static let topRogue = Vertex<ImageAnnotation>(jordanTrails[2].annotations[0])
    static let midRogue = Vertex<ImageAnnotation>(jordanTrails[2].annotations[1])
    static let botRogue = Vertex<ImageAnnotation>(jordanTrails[2].annotations[2])
//icaramba
    static let topCaram = Vertex<ImageAnnotation>(jordanTrails[3].annotations[0])
    static let botCaram = Vertex<ImageAnnotation>(jordanTrails[3].annotations[1])
//kansas
    static let topKans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[0])
    static let bend1Kans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[1])
    static let ozJunctionKans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[2])
    static let woodsmanJunctionKans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[3])
    static let bend2Kans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[4])
    static let bend3Kans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[5])
    static let bend4Kans = Vertex<ImageAnnotation>( jordanTrails[4].annotations[6])
    static let endKans = Vertex<ImageAnnotation>(jordanTrails[4].annotations[7])
    
//tin woodsman
    static let topWoodsman = Vertex<ImageAnnotation>(OzTrails[0].annotations[0])
    static let junctionWoodsman = Vertex<ImageAnnotation>(OzTrails[0].annotations[1])
    static let endWoodsman = Vertex<ImageAnnotation>(OzTrails[0].annotations[2])
    
//cyclone
    static let topCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[0])
    static let northernLightsJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[1])
    static let poppyFieldsJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[2])
    static let woodsmanJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[3])
    static let carambaJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[4])
    static let rogueAngelJunctionCyclone = Vertex<ImageAnnotation>(AuroraTrails[0].annotations[5])
//northernlights
    static let northernLightsTop = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[0])
    static let witchWayJunctionNL = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[1])
    static let kansasNLJunction = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[2])
    static let cycloneJunctionNL = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[3])
    static let bend1NL = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[4])
    static let fireStarJunctionNL = Vertex<ImageAnnotation>(AuroraTrails[1].annotations[5])
//witchway
    static let witchWayTop = Vertex<ImageAnnotation>(AuroraTrails[2].annotations[0])
    static let kansJunctionWitchWay = Vertex<ImageAnnotation>(AuroraTrails[2].annotations[1])
//airglow
    static let topAirglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[0])
    static let cycloneJunctionAirglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[1])
    static let bend1Airglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[2])
    static let blackHoleJunctionAirglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[3])
    static let bend2Airglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[4])
    static let botAirglow = Vertex<ImageAnnotation>(AuroraTrails[3].annotations[5])
//blackhole
    static let topBlackHole = Vertex<ImageAnnotation>(AuroraTrails[4].annotations[0])
    static let botBlackHole = Vertex<ImageAnnotation>(AuroraTrails[4].annotations[1])
//firestar
    static let topFirestar = Vertex<ImageAnnotation>(AuroraTrails[5].annotations[0])
    static let bend1Firestar = Vertex<ImageAnnotation>(AuroraTrails[5].annotations[1])
    static let bend2Firestar = Vertex<ImageAnnotation>(AuroraTrails[5].annotations[2])
    static let endFirestar = Vertex<ImageAnnotation>(AuroraTrails[5].annotations[3])
//lights out
    static let startLO = Vertex<ImageAnnotation>(AuroraTrails[6].annotations[0])
    static let vortexJunctionLO = Vertex<ImageAnnotation>(AuroraTrails[6].annotations[1])
    static let UpperDownDraftJunctionLO = Vertex<ImageAnnotation>(AuroraTrails[6].annotations[2])
    static let endLightsOut = Vertex<ImageAnnotation>(AuroraTrails[6].annotations[3])
//borealis
    static let topBorealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[0])
    static let bend1Borealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[1])
    static let bend2Borealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[2])
    static let vortexJunctionBorealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[3])
    static let bend3Borealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[4])
    static let endBorealis = Vertex<ImageAnnotation>(AuroraTrails[7].annotations[5])
//vortex
    static let topVortex = Vertex<ImageAnnotation>(AuroraTrails[8].annotations[0])
    static let kansasJunctionVortex = Vertex<ImageAnnotation>(AuroraTrails[8].annotations[1])
    static let botVortex = Vertex<ImageAnnotation>(AuroraTrails[8].annotations[2])
    
//paradigm
    static let topParadigm = Vertex<ImageAnnotation>(NorthPeakTrails[0].annotations[0])
    static let bend1Paradigm = Vertex<ImageAnnotation>(NorthPeakTrails[0].annotations[1])
    static let vortexJunctionParadigm = Vertex<ImageAnnotation>(NorthPeakTrails[0].annotations[2])
    static let botParadigm = Vertex<ImageAnnotation>(NorthPeakTrails[0].annotations[3])
//second mile
    static let startSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[0])
    static let GRJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[1])
    static let DMTerrainJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[2])
    static let escapadeJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[3])
    static let ThreeDJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[4])
    static let T72JunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[5])
    static let DMJunctionSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[6])
    static let endSM = Vertex<ImageAnnotation>(NorthPeakTrails[1].annotations[7])
//quantum leap
    static let topQuantum = Vertex<ImageAnnotation>(NorthPeakTrails[2].annotations[0])
    static let backsideJunctionQL = Vertex<ImageAnnotation>(NorthPeakTrails[2].annotations[1])
    static let bend1QL = Vertex<ImageAnnotation>(NorthPeakTrails[2].annotations[2])
    static let botQuantum = Vertex<ImageAnnotation>(NorthPeakTrails[2].annotations[3])
//Grand rapids
    static let topGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[0])
    static let SMJunctionGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[1])
    static let bend1GR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[2])
    static let downdraftJunctionGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[3])
    static let bend2GR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[4])
    static let bend3GR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[5])
    static let lazyRiverJunctionGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[6])
    static let endGR = Vertex<ImageAnnotation>(NorthPeakTrails[3].annotations[7])
//lower downdraft
    static let topLD = Vertex<ImageAnnotation>(NorthPeakTrails[4].annotations[0])
    static let GRJunctionLD = Vertex<ImageAnnotation>(NorthPeakTrails[4].annotations[1])
    static let AEJunctionLD = Vertex<ImageAnnotation>(NorthPeakTrails[4].annotations[2])
//dream maker
    static let topDM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[0])
    static let bend1DM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[1])
    static let TPJunctionDM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[2])
    static let Bend2DM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[3])
    static let Bend3DM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[4])
    static let RRJunctionDM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[5])
    static let Bend4DM = Vertex<ImageAnnotation>(NorthPeakTrails[5].annotations[6])
//t72
    static let topT72 = Vertex<ImageAnnotation>(NorthPeakTrails[6].annotations[0])
    static let lastMileJunctionT72 = Vertex<ImageAnnotation>(NorthPeakTrails[6].annotations[1])
    static let RRJunctionT72 = Vertex<ImageAnnotation>(NorthPeakTrails[6].annotations[2])
    static let endT72 = Vertex<ImageAnnotation>(NorthPeakTrails[6].annotations[3])
//sensation
    static let topSensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[0])
    static let bend1Sensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[1])
    static let bend2Sensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[2])
    static let bend3Sensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[3])
    static let QLJunctionSensation = Vertex<ImageAnnotation>(NorthPeakTrails[7].annotations[4])
//dream maker terrain park
    static let topDMTP = Vertex<ImageAnnotation>(NorthPeakTrails[8].annotations[0])
    static let botDMTP = Vertex<ImageAnnotation>(NorthPeakTrails[8].annotations[1])
//escapade
    static let topEscapade = Vertex<ImageAnnotation>(NorthPeakTrails[9].annotations[0])
    static let bend1Escapade = Vertex<ImageAnnotation>(NorthPeakTrails[9].annotations[1])
    static let LMJunctionEscapade = Vertex<ImageAnnotation>(NorthPeakTrails[9].annotations[2])
//3D
    static let top3D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[0])
    static let LMJunction3D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[1])
    static let RRJunction3D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[2])
    static let bend13D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[3])
    static let bot3D = Vertex<ImageAnnotation>(NorthPeakTrails[10].annotations[4])
    
    static let annotations = [botSpruce, topSpruce, botQLT, topQLT, botNP, topNP, botChondola, topChondola, auroraSideJD, jordanSideJD, botAurora, topAurora, botJord, topJord, topLol, bend1Lol, bend2Lol, topExcal, bend1Excal, midExcal, botExcal, topRogue, midRogue, botRogue, topCaram, botCaram, topKans, bend1Kans, ozJunctionKans, woodsmanJunctionKans, bend2Kans, bend3Kans, bend4Kans, endKans, topWoodsman, junctionWoodsman, endWoodsman, topCyclone, northernLightsJunctionCyclone, poppyFieldsJunctionCyclone, woodsmanJunctionCyclone, carambaJunctionCyclone, rogueAngelJunctionCyclone, northernLightsTop, witchWayJunctionNL, kansasNLJunction, cycloneJunctionNL, bend1NL, fireStarJunctionNL, witchWayTop, kansJunctionWitchWay, topAirglow, cycloneJunctionAirglow, bend1Airglow, blackHoleJunctionAirglow, bend2Airglow, botAirglow, topBlackHole, botBlackHole, topFirestar, bend1Firestar, bend2Firestar, endFirestar, topBorealis, bend1Borealis, bend2Borealis, vortexJunctionBorealis,bend3Borealis, endBorealis, topVortex, kansasJunctionVortex, botVortex, topParadigm, bend1Paradigm, vortexJunctionParadigm, botParadigm, startSM, GRJunctionSM, DMTerrainJunctionSM, escapadeJunctionSM, ThreeDJunctionSM, T72JunctionSM, DMJunctionSM, endSM, topQuantum, backsideJunctionQL, bend1QL, botQuantum, topGR, SMJunctionGR, bend1GR, downdraftJunctionGR, bend2GR, bend3GR, lazyRiverJunctionGR, endGR, topLD, GRJunctionLD, AEJunctionLD, topDM, bend1DM, TPJunctionDM, Bend2DM, Bend3DM, RRJunctionDM, Bend4DM, topT72, lastMileJunctionT72, RRJunctionT72, endT72, topSensation, bend1Sensation, bend2Sensation, bend3Sensation, QLJunctionSensation, topDMTP, botDMTP, topEscapade, bend1Escapade, LMJunctionEscapade, top3D, LMJunction3D, RRJunction3D, bend13D, bot3D, startLO, vortexJunctionLO, UpperDownDraftJunctionLO, endLightsOut]
    
    static let graph = EdgeWeightedDigraph<ImageAnnotation>()
    
    static func addVertexes(){
        for vertex in annotations{
            graph.addVertex(vertex)
        }
    }
    static func createEdges()
    {
        
        //Jordan
                graph.addEdge(direction: .undirected, from: jordanSideJD, to: botJord, weight: 100)
                graph.addEdge(direction: .directed, from: botJord, to: topJord, weight: 100)
        //lollapalooza
                graph.addEdge(direction: .undirected, from: topJord, to: topLol, weight: 1)
                graph.addEdge(direction: .directed, from: topLol, to: bend1Lol, weight: 1)
                graph.addEdge(direction: .directed, from: bend1Lol, to: bend2Lol, weight: 1)
                graph.addEdge(direction: .directed, from: bend2Lol, to: botJord, weight: 1)
        //excalibur
                graph.addEdge(direction: .directed, from: topLol, to: topExcal, weight: 1)
                graph.addEdge(direction: .directed, from: topExcal, to: bend1Excal, weight: 50)
                graph.addEdge(direction: .directed, from: bend1Excal, to: midExcal, weight: 50)
                graph.addEdge(direction: .directed, from: midExcal, to: botExcal, weight: 50)
                graph.addEdge(direction: .directed, from: botExcal, to: botJord, weight: 50)
        //rogue
                graph.addEdge(direction: .undirected, from: topJord, to: topRogue, weight: 1)
                graph.addEdge(direction: .directed, from: topRogue, to: midRogue, weight: 50)
                graph.addEdge(direction: .directed, from: topRogue, to: topCaram, weight: 50)
                graph.addEdge(direction: .directed, from: midRogue, to: botRogue, weight: 50)
                graph.addEdge(direction: .directed, from: botRogue, to: rogueAngelJunctionCyclone, weight: 50)
        //iCaramba
                graph.addEdge(direction: .directed, from: topCaram, to: botCaram, weight: 4000)
                graph.addEdge(direction: .directed, from: botCaram, to: carambaJunctionCyclone, weight: 4000)
        //kansas
                graph.addEdge(direction: .undirected, from: topJord, to: topKans, weight: 1)
                graph.addEdge(direction: .directed, from: topKans, to: bend1Kans, weight: 1)
                graph.addEdge(direction: .directed, from: bend1Kans, to: ozJunctionKans, weight: 1)
                graph.addEdge(direction: .directed, from: ozJunctionKans, to: woodsmanJunctionKans, weight: 1)
                graph.addEdge(direction: .undirected, from: junctionWoodsman, to: woodsmanJunctionKans, weight: 1)
                graph.addEdge(direction: .directed, from: woodsmanJunctionKans, to: bend2Kans, weight: 1)
                graph.addEdge(direction: .directed, from: bend2Kans, to: bend3Kans, weight: 1)
                graph.addEdge(direction: .directed, from: bend3Kans, to: bend4Kans, weight: 1)
                graph.addEdge(direction: .directed, from: bend4Kans, to: kansJunctionWitchWay, weight: 1)
                
                graph.addEdge(direction: .directed, from: endKans, to: topCyclone, weight: 1)
                graph.addEdge(direction: .directed, from: endKans, to: northernLightsJunctionCyclone, weight: 1)
        //woodsman
                graph.addEdge(direction: .directed, from: topWoodsman, to: junctionWoodsman, weight: 4000)
                graph.addEdge(direction: .undirected, from: junctionWoodsman, to: woodsmanJunctionKans, weight: 1)
                graph.addEdge(direction: .directed, from: junctionWoodsman, to: endWoodsman, weight: 4000)
                graph.addEdge(direction: .undirected, from: endWoodsman, to: woodsmanJunctionCyclone, weight: 4000)
        //Cyclone
                graph.addEdge(direction: .directed, from: topCyclone, to: northernLightsJunctionCyclone, weight: 1)
                graph.addEdge(direction: .undirected, from: topCyclone, to: startLO, weight: 1)
                graph.addEdge(direction: .directed, from: northernLightsJunctionCyclone, to: poppyFieldsJunctionCyclone, weight: 1)
                graph.addEdge(direction: .directed, from: northernLightsJunctionCyclone, to: bend1NL, weight: 1)
                graph.addEdge(direction: .directed, from: poppyFieldsJunctionCyclone, to: woodsmanJunctionCyclone, weight: 1)
                graph.addEdge(direction: .directed, from: woodsmanJunctionCyclone, to: carambaJunctionCyclone, weight: 1)
                graph.addEdge(direction: .directed, from: carambaJunctionCyclone, to: rogueAngelJunctionCyclone, weight: 1)
                graph.addEdge(direction: .directed, from: rogueAngelJunctionCyclone, to: botJord, weight: 1)
        //Aurora
                graph.addEdge(direction: .directed, from: botAurora, to: topAurora, weight: 100)
                graph.addEdge(direction: .undirected, from: botAurora, to: auroraSideJD, weight: 1)
                graph.addEdge(direction: .undirected, from: botAurora, to: botQLT, weight: 1)
        //Jordan double
                graph.addEdge(direction: .undirected, from: auroraSideJD, to: jordanSideJD, weight: 100)
        //northernlights
                graph.addEdge(direction: .undirected, from: topAurora, to: northernLightsTop, weight: 50)
                graph.addEdge(direction: .directed, from: northernLightsTop, to: witchWayJunctionNL, weight: 50)
                graph.addEdge(direction: .undirected, from: witchWayJunctionNL, to: witchWayTop, weight: 50)
                graph.addEdge(direction: .directed, from: witchWayJunctionNL, to: kansasNLJunction, weight: 50)
                graph.addEdge(direction: .undirected, from: kansasNLJunction, to: topCyclone, weight: 50)
                graph.addEdge(direction: .directed, from: kansasNLJunction, to: cycloneJunctionNL, weight: 50)
                graph.addEdge(direction: .undirected, from: kansasNLJunction, to: endKans, weight: 50)
                graph.addEdge(direction: .undirected, from: cycloneJunctionNL, to: northernLightsJunctionCyclone, weight: 50)
                graph.addEdge(direction: .directed, from: cycloneJunctionNL, to: bend1NL, weight: 50)
                graph.addEdge(direction: .directed, from: bend1NL, to: fireStarJunctionNL, weight: 50)
                graph.addEdge(direction: .undirected, from: fireStarJunctionNL, to: topFirestar, weight: 50)
                graph.addEdge(direction: .directed, from: fireStarJunctionNL, to: botAurora, weight: 50)
        //witchway
                graph.addEdge(direction: .directed, from: witchWayTop, to: kansJunctionWitchWay, weight: 50)
                graph.addEdge(direction: .directed, from: kansJunctionWitchWay, to: endKans, weight: 1)
        //firestar
                graph.addEdge(direction: .directed, from: topFirestar, to: bend1Firestar, weight: 50)
                graph.addEdge(direction: .directed, from: bend1Firestar, to: bend2Firestar, weight: 50)
                graph.addEdge(direction: .directed, from: bend2Firestar, to: endFirestar, weight: 50)
                graph.addEdge(direction: .directed, from: endFirestar, to: botJord, weight: 50)
        //Borealis
                graph.addEdge(direction: .undirected, from: topAurora, to: topBorealis, weight: 1)
                graph.addEdge(direction: .directed, from: topBorealis, to: bend1Borealis, weight: 1)
                graph.addEdge(direction: .directed, from: bend1Borealis, to: bend2Borealis, weight: 1)
                graph.addEdge(direction: .directed, from: bend2Borealis, to: vortexJunctionBorealis, weight: 1)
                graph.addEdge(direction: .undirected, from: vortexJunctionBorealis, to: topVortex, weight: 1)
                graph.addEdge(direction: .directed, from: vortexJunctionBorealis, to: bend3Borealis, weight: 1)
                graph.addEdge(direction: .directed, from: bend3Borealis, to: endBorealis, weight: 1)
                graph.addEdge(direction: .directed, from: endBorealis, to: startLO, weight: 1)
                graph.addEdge(direction: .directed, from: endBorealis, to: topCyclone, weight: 1)
        //Vortex
                graph.addEdge(direction: .directed, from: topVortex, to: kansasJunctionVortex, weight: 4000)
                graph.addEdge(direction: .directed, from: kansasJunctionVortex, to: botVortex, weight: 4000)
                graph.addEdge(direction: .undirected, from: botVortex, to: vortexJunctionParadigm, weight: 4000)
        //Airglow
                graph.addEdge(direction: .undirected, from: topAurora, to: topAirglow, weight: 300)
                graph.addEdge(direction: .directed, from: topAirglow, to: cycloneJunctionAirglow, weight: 300)
                graph.addEdge(direction: .undirected, from: cycloneJunctionAirglow, to: topCyclone, weight: 1)
                graph.addEdge(direction: .directed, from: cycloneJunctionAirglow, to: bend1Airglow, weight: 300)
                graph.addEdge(direction: .directed, from: bend1Airglow, to: blackHoleJunctionAirglow, weight: 300)
                graph.addEdge(direction: .undirected, from: blackHoleJunctionAirglow, to: topBlackHole, weight: 300)
                graph.addEdge(direction: .directed, from: blackHoleJunctionAirglow, to: bend2Airglow, weight: 300)
                graph.addEdge(direction: .directed, from: bend2Airglow, to: botAirglow, weight: 300)
                graph.addEdge(direction: .directed, from: botAirglow, to: botAurora, weight: 300)
        //blackHole
                graph.addEdge(direction: .directed, from: topBlackHole, to: botBlackHole, weight: 4000)
                graph.addEdge(direction: .directed, from: botBlackHole, to: botAirglow, weight: 4000)
        //LightsOut
                graph.addEdge(direction: .directed, from: startLO, to: vortexJunctionLO, weight: 1)
                graph.addEdge(direction: .undirected, from: vortexJunctionLO, to: kansasJunctionVortex, weight: 1)
                graph.addEdge(direction: .directed, from: vortexJunctionLO, to: UpperDownDraftJunctionLO, weight: 1)
                graph.addEdge(direction: .directed, from: UpperDownDraftJunctionLO, to: endLightsOut, weight: 1)
                graph.addEdge(direction: .directed, from: endLightsOut, to: topChondola, weight: 1)
        //Chondola
                graph.addEdge(direction: .directed, from: botChondola, to: topChondola, weight: 100)
        //North Peak Quad
                graph.addEdge(direction: .directed, from: botNP, to: topNP, weight: 100)
        //paradigm
                graph.addEdge(direction: .undirected, from: topChondola, to: topParadigm, weight: 50)
                graph.addEdge(direction: .directed, from: topParadigm, to: bend1Paradigm, weight: 50)
                graph.addEdge(direction: .directed, from: bend1Paradigm, to: vortexJunctionParadigm, weight: 50)
                graph.addEdge(direction: .directed, from: vortexJunctionParadigm, to: botParadigm, weight: 50)
                graph.addEdge(direction: .directed, from: botParadigm, to: botAurora, weight: 50)
        //secondMile
                graph.addEdge(direction: .directed, from: topChondola, to: startSM, weight: 1)
                graph.addEdge(direction: .directed, from: startSM, to: GRJunctionSM, weight: 1)
                graph.addEdge(direction: .undirected, from: GRJunctionSM, to: SMJunctionGR, weight: 1)
                graph.addEdge(direction: .directed, from: GRJunctionSM, to: DMTerrainJunctionSM, weight: 1)
                graph.addEdge(direction: .undirected, from: DMTerrainJunctionSM, to: botDMTP, weight: 1)
                graph.addEdge(direction: .directed, from: DMTerrainJunctionSM, to: escapadeJunctionSM, weight: 1)
                graph.addEdge(direction: .undirected, from: escapadeJunctionSM, to: topEscapade, weight: 1)
                graph.addEdge(direction: .directed, from: escapadeJunctionSM, to: ThreeDJunctionSM, weight: 1)
                graph.addEdge(direction: .undirected, from: ThreeDJunctionSM, to: top3D, weight: 1)
                graph.addEdge(direction: .directed, from: ThreeDJunctionSM, to: T72JunctionSM, weight: 1)
                graph.addEdge(direction: .undirected, from: T72JunctionSM, to: topT72, weight: 1)
                graph.addEdge(direction: .directed, from: T72JunctionSM, to: DMJunctionSM, weight: 1)
                graph.addEdge(direction: .undirected, from: DMJunctionSM, to: Bend2DM, weight: 1)
                graph.addEdge(direction: .directed, from: DMJunctionSM, to: endSM, weight: 1)
                graph.addEdge(direction: .directed, from: endSM, to: topSensation, weight: 1)
        //grand rapids
                graph.addEdge(direction: .undirected, from: topNP, to: topGR, weight: 50)
                graph.addEdge(direction: .directed, from: topGR, to: SMJunctionGR, weight: 50)
                graph.addEdge(direction: .directed, from: SMJunctionGR, to: bend1GR, weight: 50)
                graph.addEdge(direction: .directed, from: bend1GR, to: downdraftJunctionGR, weight: 50)
                graph.addEdge(direction: .directed, from: downdraftJunctionGR, to: bend2GR, weight: 50)
                graph.addEdge(direction: .directed, from: bend2GR, to: bend3GR, weight: 50)
                graph.addEdge(direction: .directed, from: bend3GR, to: lazyRiverJunctionGR, weight: 50)
                graph.addEdge(direction: .directed, from: lazyRiverJunctionGR, to: endGR, weight: 50)
                graph.addEdge(direction: .directed, from: endGR, to: botSpruce, weight: 50)
        //Dream Maker
                graph.addEdge(direction: .undirected, from: topNP, to: topDM, weight: 1)
                graph.addEdge(direction: .directed, from: topDM, to: bend1DM, weight: 1)
                graph.addEdge(direction: .directed, from: bend1DM, to: TPJunctionDM, weight: 1)
                graph.addEdge(direction: .undirected, from: TPJunctionDM, to: topDMTP, weight: 1)
                graph.addEdge(direction: .directed, from: TPJunctionDM, to: Bend2DM, weight: 1)
                graph.addEdge(direction: .directed, from: Bend2DM, to: Bend3DM, weight: 1)
                graph.addEdge(direction: .directed, from: Bend3DM, to: Bend4DM, weight: 1)
                graph.addEdge(direction: .undirected, from: Bend4DM, to: RRJunctionDM, weight: 1)
                graph.addEdge(direction: .directed, from: Bend4DM, to: botNP, weight: 1)
        //DMTP
                graph.addEdge(direction: .directed, from: topDMTP, to: botDMTP, weight: 1)
        //Escapade
                graph.addEdge(direction: .directed, from: topEscapade, to: bend1Escapade, weight: 50)
                graph.addEdge(direction: .directed, from: bend1Escapade, to: LMJunctionEscapade, weight: 50)
        //3D
                graph.addEdge(direction: .directed, from: top3D, to: LMJunction3D, weight: 50)
                graph.addEdge(direction: .directed, from: LMJunction3D, to: RRJunction3D, weight: 50)
                graph.addEdge(direction: .directed, from: RRJunction3D, to: bend13D, weight: 50)
                graph.addEdge(direction: .directed, from: bend13D, to: bot3D, weight: 50)
                graph.addEdge(direction: .directed, from: bot3D, to: botNP, weight: 50)
        //T72
                graph.addEdge(direction: .directed, from: topT72, to: lastMileJunctionT72, weight: 50)
                graph.addEdge(direction: .directed, from: lastMileJunctionT72, to: RRJunctionT72, weight: 50)
                graph.addEdge(direction: .directed, from: RRJunctionT72, to: endT72, weight: 50)
                graph.addEdge(direction: .directed, from: endT72, to: botNP, weight: 50)
        //Sensation
                graph.addEdge(direction: .directed, from: topSensation, to: bend1Sensation, weight: 1)
                graph.addEdge(direction: .directed, from: bend1Sensation, to: bend2Sensation, weight: 1)
                graph.addEdge(direction: .directed, from: bend2Sensation, to: bend3Sensation, weight: 1)
                graph.addEdge(direction: .directed, from: bend3Sensation, to: QLJunctionSensation, weight: 1)
                graph.addEdge(direction: .directed, from: QLJunctionSensation, to: botAurora, weight: 1)
                graph.addEdge(direction: .undirected, from: QLJunctionSensation, to: botQLT, weight: 1)
        //Quantum Leap
                graph.addEdge(direction: .undirected, from: topQLT, to: topQuantum, weight: 4000)
                graph.addEdge(direction: .undirected, from: topNP, to: topQuantum, weight: 4000)
                graph.addEdge(direction: .directed, from: topQuantum, to: backsideJunctionQL, weight: 4000)
                graph.addEdge(direction: .directed, from: backsideJunctionQL, to: bend1QL, weight: 4000)
                graph.addEdge(direction: .directed, from: bend1QL, to: QLJunctionSensation, weight: 4000)
        //Quantum Leap Triple
                graph.addEdge(direction: .directed, from: botQLT, to: topQLT, weight: 100)
                graph.addEdge(direction: .undirected, from: topQLT, to: topNP, weight: 100)
        //lowerdowndraft
                graph.addEdge(direction: .directed, from: topChondola, to: topLD, weight:  50)
                graph.addEdge(direction: .directed, from: topLD, to: GRJunctionLD, weight: 50)
                graph.addEdge(direction: .directed, from: GRJunctionLD, to: downdraftJunctionGR, weight:  50)
                graph.addEdge(direction: .directed, from: GRJunctionLD, to: AEJunctionLD, weight:  50)
        //spruce triple
                graph.addEdge(direction: .directed, from: botSpruce, to: topSpruce, weight:  100)
        print("test edges")
        print(graph.edgesCount())
    }
//    static let excalSet = Node(Trails[1].annotations[0],
//                                children: [Node(Trails[1].annotations[1],
//                                                children: [Node(Trails[1].annotations[2],
//                                                                children: [Node(Trails[1].annotations[3],
//                                                                                children: [jordSet])])])])
//    static let rogueSet = Node(Trails[2].annotations[0],
//                               children: [Node(Trails[2].annotations[1],
//                                               children: [Node(Trails[2].annotations[2],
//                                                               children: [jordSet])]), caramSet])
//
//    static let caramSet = Node(Trails[3].annotations[0],
//                               children: [Node(Trails[3].annotations[1],
//                                               children: [cycloneSet.children[0].children[0].children[0].children[0]])])
//
//    static let kansSet : Node<MKPointAnnotation> = Node(Trails[4].annotations[0], children: [Node(Trails[4].annotations[1], children: [Node(Trails[4].annotations[2], children: [Node(Trails[4].annotations[3], children: [Node(Trails[4].annotations[3], children: [Node(Trails[4].annotations[4], children: [Node(Trails[4].annotations[5], children: [Node(Trails[4].annotations[6]), cycloneSet.children[0]])])])])]), woodsmanSet.children[0].children[0]])])
//
//    static let lolSet : Node<MKPointAnnotation> = Node(Trails[0].annotations[0],
//                             children: [Node(Trails[0].annotations[1],
//                                             children: [Node(Trails[0].annotations[2],
//                                                             children: [jordSet])]),
//                                        excalSet, rogueSet, kansSet])
//
//    static let jordSet = Node(Lifts[0].annotations[0], children: [Node(Lifts[0].annotations[1], children: [lolSet])])
//
//    static let cycloneSet = Node(Trails[6].annotations[0], children: [Node(Trails[6].annotations[1], children: [Node(Trails[6].annotations[2], children: [Node(Trails[6].annotations[3], children: [Node(Trails[6].annotations[4], children: [Node(Trails[6].annotations[5], children: [jordSet])])])])])])
//
//    static let woodsmanSet = Node(Trails[6].annotations[0], children: [Node(Trails[6].annotations[1], children: [Node(Trails[6].annotations[2]), cycloneSet.children[0].children[0].children[0]]), kansSet.children[0].children[0]])
//
//    static let TrailDatastructure = lolSet
    
    static func createAnnotation(title: String, latitude: Double, longitude: Double, difficulty: Difficulty) -> ImageAnnotation
    {
        let point = ImageAnnotation()
        point.title = title
        point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        point.difficulty = difficulty
        return point
    }
}
