--!strict
local Tekscripts = {}
Tekscripts.__index = Tekscripts

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- tabela de ícones
local icones = {
        accessibility = 10709751939,
        activity = 10709752035,
        airvent = 10709752131,
        airplay = 10709752254,
        alarmcheck = 10709752405,
        alarmclock = 10709752630,
        alarmclockoff = 10709752508,
        alarmminus = 10709752732,
        alarmplus = 10709752825,
        album = 10709752906,
        alertcircle = 10709752996,
        alertoctagon = 10709753064,
        alerttriangle = 10709753149,
        aligncenter = 10709753570,
        aligncenterhorizontal = 10709753272,
        aligncentervertical = 10709753421,
        alignendhorizontal = 10709753692,
        alignendvertical = 10709753808,
        alignhorizontaldistributecenter = 10747779791,
        alignhorizontaldistributeend = 10747784534,
        alignhorizontaldistributestart = 10709754118,
        alignhorizontaljustifycenter = 10709754204,
        alignhorizontaljustifyend = 10709754317,
        alignhorizontaljustifystart = 10709754436,
        alignhorizontalspacearound = 10709754590,
        alignhorizontalspacebetween = 10709754749,
        alignjustify = 10709759610,
        alignleft = 10709759764,
        alignright = 10709759895,
        alignstarthorizontal = 10709760051,
        alignstartvertical = 10709760244,
        alignverticaldistributecenter = 10709760351,
        alignverticaldistributeend = 10709760434,
        alignverticaldistributestart = 10709760612,
        alignverticaljustifycenter = 10709760814,
        alignverticaljustifyend = 10709761003,
        alignverticaljustifystart = 10709761176,
        alignverticalspacearound = 10709761324,
        alignverticalspacebetween = 10709761434,
        anchor = 10709761530,
        angry = 10709761629,
        annoyed = 10709761722,
        aperture = 10709761813,
        apple = 10709761889,
        archive = 10709762233,
        archiverestore = 10709762058,
        armchair = 10709762327,
        arrowbigdown = 10747796644,
        arrowbigleft = 10709762574,
        arrowbigright = 10709762727,
        arrowbigup = 10709762879,
        arrowdown = 10709767827,
        arrowdowncircle = 10709763034,
        arrowdownleft = 10709767656,
        arrowdownright = 10709767750,
        arrowleft = 10709768114,
        arrowleftcircle = 10709767936,
        arrowleftright = 10709768019,
        arrowright = 10709768347,
        arrowrightcircle = 10709768226,
        arrowup = 10709768939,
        arrowupcircle = 10709768432,
        arrowupdown = 10709768538,
        arrowupleft = 10709768661,
        arrowupright = 10709768787,
        asterisk = 10709769095,
        atsign = 10709769286,
        award = 10709769406,
        axe = 10709769508,
        axis3d = 10709769598,
        baby = 10709769732,
        backpack = 10709769841,
        baggageclaim = 10709769935,
        banana = 10709770005,
        banknote = 10709770178,
        barchart = 10709773755,
        barchart2 = 10709770317,
        barchart3 = 10709770431,
        barchart4 = 10709770560,
        barcharthorizontal = 10709773669,
        barcode = 10747360675,
        baseline = 10709773863,
        bath = 10709773963,
        battery = 10709774640,
        batterycharging = 10709774068,
        batteryfull = 10709774206,
        batterylow = 10709774370,
        batterymedium = 10709774513,
        beaker = 10709774756,
        bed = 10709775036,
        beddouble = 10709774864,
        bedsingle = 10709774968,
        beer = 10709775167,
        bell = 10709775704,
        bellminus = 10709775241,
        belloff = 10709775320,
        bellplus = 10709775448,
        bellring = 10709775560,
        bike = 10709775894,
        binary = 10709776050,
        bitcoin = 10709776126,
        bluetooth = 10709776655,
        bluetoothconnected = 10709776240,
        bluetoothoff = 10709776344,
        bluetoothsearching = 10709776501,
        bold = 10747813908,
        bomb = 10709781460,
        bone = 10709781605,
        book = 10709781824,
        bookopen = 10709781717,
        bookmark = 10709782154,
        bookmarkminus = 10709781919,
        bookmarkplus = 10709782044,
        bot = 10709782230,
        box = 10709782497,
        boxselect = 10709782342,
        boxes = 10709782582,
        briefcase = 10709782662,
        brush = 10709782758,
        bug = 10709782845,
        building = 10709783051,
        building2 = 10709782939,
        bus = 10709783137,
        cake = 10709783217,
        calculator = 10709783311,
        calendar = 10709789505,
        calendarcheck = 10709783474,
        calendarcheck2 = 10709783392,
        calendarclock = 10709783577,
        calendardays = 10709783673,
        calendarheart = 10709783835,
        calendarminus = 10709783959,
        calendaroff = 10709788784,
        calendarplus = 10709788937,
        calendarrange = 10709789053,
        calendarsearch = 10709789200,
        calendarx = 10709789407,
        calendarx2 = 10709789329,
        camera = 10709789686,
        cameraoff = 10747822677,
        car = 10709789810,
        carrot = 10709789960,
        cast = 10709790097,
        charge = 10709790202,
        check = 10709790644,
        checkcircle = 10709790387,
        checkcircle2 = 10709790298,
        checksquare = 10709790537,
        chefhat = 10709790757,
        cherry = 10709790875,
        chevrondown = 10709790948,
        chevronfirst = 10709791015,
        chevronlast = 10709791130,
        chevronleft = 10709791281,
        chevronright = 10709791437,
        chevronup = 10709791523,
        chevronsdown = 10709796864,
        chevronsdownup = 10709791632,
        chevronsleft = 10709797151,
        chevronsleftright = 10709797006,
        chevronsright = 10709797382,
        chevronsrightleft = 10709797274,
        chevronsup = 10709797622,
        chevronsupdown = 10709797508,
        chrome = 10709797725,
        circle = 10709798174,
        circledot = 10709797837,
        circleellipsis = 10709797985,
        circleslashed = 10709798100,
        citrus = 10709798276,
        clapperboard = 10709798350,
        clipboard = 10709799288,
        clipboardcheck = 10709798443,
        clipboardcopy = 10709798574,
        clipboardedit = 10709798682,
        clipboardlist = 10709798792,
        clipboardsignature = 10709798890,
        clipboardtype = 10709798999,
        clipboardx = 10709799124,
        clock = 10709805144,
        clock1 = 10709799535,
        clock10 = 10709799718,
        clock11 = 10709799818,
        clock12 = 10709799962,
        clock2 = 10709803876,
        clock3 = 10709803989,
        clock4 = 10709804164,
        clock5 = 10709804291,
        clock6 = 10709804435,
        clock7 = 10709804599,
        clock8 = 10709804784,
        clock9 = 10709804996,
        cloud = 10709806740,
        cloudcog = 10709805262,
        clouddrizzle = 10709805371,
        cloudfog = 10709805477,
        cloudhail = 10709805596,
        cloudlightning = 10709805727,
        cloudmoon = 10709805942,
        cloudmoonrain = 10709805838,
        cloudoff = 10709806060,
        cloudrain = 10709806277,
        cloudrainwind = 10709806166,
        cloudsnow = 10709806374,
        cloudsun = 10709806631,
        cloudsunrain = 10709806475,
        cloudy = 10709806859,
        clover = 10709806995,
        code = 10709810463,
        code2 = 10709807111,
        codepen = 10709810534,
        codesandbox = 10709810676,
        coffee = 10709810814,
        cog = 10709810948,
        coins = 10709811110,
        columns = 10709811261,
        command = 10709811365,
        compass = 10709811445,
        component = 10709811595,
        conciergebell = 10709811706,
        connection = 10747361219,
        contact = 10709811834,
        contrast = 10709811939,
        cookie = 10709812067,
        copy = 10709812159,
        copyleft = 10709812251,
        copyright = 10709812311,
        cornerdownleft = 10709812396,
        cornerdownright = 10709812485,
        cornerleftdown = 10709812632,
        cornerleftup = 10709812784,
        cornerrightdown = 10709812939,
        cornerrightup = 10709813094,
        cornerupleft = 10709813185,
        cornerupright = 10709813281,
        cpu = 10709813383,
        croissant = 10709818125,
        crop = 10709818245,
        cross = 10709818399,
        crosshair = 10709818534,
        crown = 10709818626,
        cupsoda = 10709818763,
        curlybraces = 10709818847,
        currency = 10709818931,
        database = 10709818996,
        delete = 10709819059,
        diamond = 10709819149,
        dice1 = 10709819266,
        dice2 = 10709819361,
        dice3 = 10709819508,
        dice4 = 10709819670,
        dice5 = 10709819801,
        dice6 = 10709819896,
        dices = 10723343321,
        diff = 10723343416,
        disc = 10723343537,
        divide = 10723343805,
        dividecircle = 10723343636,
        dividesquare = 10723343737,
        dollarsign = 10723343958,
        download = 10723344270,
        downloadcloud = 10723344088,
        droplet = 10723344432,
        droplets = 10734883356,
        drumstick = 10723344737,
        edit = 10734883598,
        edit2 = 10723344885,
        edit3 = 10723345088,
        egg = 10723345518,
        eggfried = 10723345347,
        electricity = 10723345749,
        electricityoff = 10723345643,
        equal = 10723345990,
        equalnot = 10723345866,
        eraser = 10723346158,
        euro = 10723346372,
        expand = 10723346553,
        externallink = 10723346684,
        eye = 10723346959,
        eyeoff = 10723346871,
        factory = 10723347051,
        fan = 10723354359,
        fastforward = 10723354521,
        feather = 10723354671,
        figma = 10723354801,
        file = 10723374641,
        filearchive = 10723354921,
        fileaudio = 10723355148,
        fileaudio2 = 10723355026,
        fileaxis3d = 10723355272,
        filebadge = 10723355622,
        filebadge2 = 10723355451,
        filebarchart = 10723355887,
        filebarchart2 = 10723355746,
        filebox = 10723355989,
        filecheck = 10723356210,
        filecheck2 = 10723356100,
        fileclock = 10723356329,
        filecode = 10723356507,
        filecog = 10723356830,
        filecog2 = 10723356676,
        filediff = 10723357039,
        filedigit = 10723357151,
        filedown = 10723357322,
        fileedit = 10723357495,
        fileheart = 10723357637,
        fileimage = 10723357790,
        fileinput = 10723357933,
        filejson = 10723364435,
        filejson2 = 10723364361,
        filekey = 10723364605,
        filekey2 = 10723364515,
        filelinechart = 10723364725,
        filelock = 10723364957,
        filelock2 = 10723364861,
        fileminus = 10723365254,
        fileminus2 = 10723365086,
        fileoutput = 10723365457,
        filepiechart = 10723365598,
        fileplus = 10723365877,
        fileplus2 = 10723365766,
        filequestion = 10723365987,
        filescan = 10723366167,
        filesearch = 10723366550,
        filesearch2 = 10723366340,
        filesignature = 10723366741,
        filespreadsheet = 10723366962,
        filesymlink = 10723367098,
        fileterminal = 10723367244,
        filetext = 10723367380,
        filetype = 10723367606,
        filetype2 = 10723367509,
        fileup = 10723367734,
        filevideo = 10723373884,
        filevideo2 = 10723367834,
        filevolume = 10723374172,
        filevolume2 = 10723374030,
        filewarning = 10723374276,
        filex = 10723374544,
        filex2 = 10723374378,
        files = 10723374759,
        film = 10723374981,
        filter = 10723375128,
        fingerprint = 10723375250,
        fish = 127664059821666,
        flag = 10723375890,
        flagoff = 10723375443,
        flagtriangleleft = 10723375608,
        flagtriangleright = 10723375727,
        flame = 10723376114,
        flashlight = 10723376471,
        flashlightoff = 10723376365,
        flaskconical = 10734883986,
        flaskround = 10723376614,
        fliphorizontal = 10723376884,
        fliphorizontal2 = 10723376745,
        flipvertical = 10723377138,
        flipvertical2 = 10723377026,
        flower = 10747830374,
        flower2 = 10723377305,
        focus = 10723377537,
        folder = 10723387563,
        folderarchive = 10723384478,
        foldercheck = 10723384605,
        folderclock = 10723384731,
        folderclosed = 10723384893,
        foldercog = 10723385213,
        foldercog2 = 10723385036,
        folderdown = 10723385338,
        folderedit = 10723385445,
        folderheart = 10723385545,
        folderinput = 10723385721,
        folderkey = 10723385848,
        folderlock = 10723386005,
        folderminus = 10723386127,
        folderopen = 10723386277,
        folderoutput = 10723386386,
        folderplus = 10723386531,
        foldersearch = 10723386787,
        foldersearch2 = 10723386674,
        foldersymlink = 10723386930,
        foldertree = 10723387085,
        folderup = 10723387265,
        folderx = 10723387448,
        folders = 10723387721,
        forminput = 10723387841,
        forward = 10723388016,
        frame = 10723394389,
        framer = 10723394565,
        frown = 10723394681,
        fuel = 10723394846,
        functionsquare = 10723395041,
        gamepad = 10723395457,
        gamepad2 = 10723395215,
        gauge = 10723395708,
        gavel = 10723395896,
        gem = 10723396000,
        ghost = 10723396107,
        gift = 10723396402,
        giftcard = 10723396225,
        gitbranch = 10723396676,
        gitbranchplus = 10723396542,
        gitcommit = 10723396812,
        gitcompare = 10723396954,
        gitfork = 10723397049,
        gitmerge = 10723397165,
        gitpullrequest = 10723397431,
        gitpullrequestclosed = 10723397268,
        gitpullrequestdraft = 10734884302,
        glass = 10723397788,
        glass2 = 10723397529,
        glasswater = 10723397678,
        glasses = 10723397895,
        globe = 10723404337,
        globe2 = 10723398002,
        grab = 10723404472,
        graduationcap = 10723404691,
        grape = 10723404822,
        grid = 10723404936,
        griphorizontal = 10723405089,
        gripvertical = 10723405236,
        hammer = 10723405360,
        hand = 10723405649,
        handmetal = 10723405508,
        harddrive = 10723405749,
        hardhat = 10723405859,
        hash = 10723405975,
        haze = 10723406078,
        headphones = 10723406165,
        heart = 10723406885,
        heartcrack = 10723406299,
        hearthandshake = 10723406480,
        heartoff = 10723406662,
        heartpulse = 10723406795,
        helpcircle = 10723406988,
        hexagon = 10723407092,
        highlighter = 10723407192,
        history = 10723407335,
        home = 10723407389,
        hourglass = 10723407498,
        icecream = 10723414308,
        image = 10723415040,
        imageminus = 10723414487,
        imageoff = 10723414677,
        imageplus = 10723414827,
        import = 10723415205,
        inbox = 10723415335,
        indent = 10723415494,
        indianrupee = 10723415642,
        infinity = 10723415766,
        info = 10723415903,
        inspect = 10723416057,
        italic = 10723416195,
        japaneseyen = 10723416363,
        joystick = 10723416527,
        key = 10723416652,
        keyboard = 10723416765,
        lamp = 10723417513,
        lampceiling = 10723416922,
        lampdesk = 10723417016,
        lampfloor = 10723417131,
        lampwalldown = 10723417240,
        lampwallup = 10723417356,
        landmark = 10723417608,
        languages = 10723417703,
        laptop = 10723423881,
        laptop2 = 10723417797,
        lasso = 10723424235,
        lassoselect = 10723424058,
        laugh = 10723424372,
        layers = 10723424505,
        layout = 10723425376,
        layoutdashboard = 10723424646,
        layoutgrid = 10723424838,
        layoutlist = 10723424963,
        layouttemplate = 10723425187,
        leaf = 10723425539,
        library = 10723425615,
        lifebuoy = 10723425685,
        lightbulb = 10723425852,
        lightbulboff = 10723425762,
        linechart = 10723426393,
        link = 10723426722,
        link2 = 10723426595,
        link2off = 10723426513,
        list = 10723433811,
        listchecks = 10734884548,
        listend = 10723426886,
        listminus = 10723426986,
        listmusic = 10723427081,
        listordered = 10723427199,
        listplus = 10723427334,
        liststart = 10723427494,
        listvideo = 10723427619,
        listx = 10723433655,
        loader = 10723434070,
        loader2 = 10723433935,
        locate = 10723434557,
        locatefixed = 10723434236,
        locateoff = 10723434379,
        lock = 10723434711,
        login = 10723434830,
        logout = 10723434906,
        luggage = 10723434993,
        magnet = 10723435069,
        mail = 10734885430,
        mailcheck = 10723435182,
        mailminus = 10723435261,
        mailopen = 10723435342,
        mailplus = 10723435443,
        mailquestion = 10723435515,
        mailsearch = 10734884739,
        mailwarning = 10734885015,
        mailx = 10734885247,
        mails = 10734885614,
        map = 10734886202,
        mappin = 10734886004,
        mappinoff = 10734885803,
        maximize = 10734886735,
        maximize2 = 10734886496,
        medal = 10734887072,
        megaphone = 10734887454,
        megaphoneoff = 10734887311,
        meh = 10734887603,
        menu = 10734887784,
        messagecircle = 10734888000,
        messagesquare = 10734888228,
        mic = 10734888864,
        mic2 = 10734888430,
        micoff = 10734888646,
        microscope = 10734889106,
        microwave = 10734895076,
        milestone = 10734895310,
        minimize = 10734895698,
        minimize2 = 10734895530,
        minus = 10734896206,
        minuscircle = 10734895856,
        minussquare = 10734896029,
        monitor = 10734896881,
        monitoroff = 10734896360,
        monitorspeaker = 10734896512,
        moon = 10734897102,
        morehorizontal = 10734897250,
        morevertical = 10734897387,
        mountain = 10734897956,
        mountainsnow = 10734897665,
        mouse = 10734898592,
        mousepointer = 10734898476,
        mousepointer2 = 10734898194,
        mousepointerclick = 10734898355,
        move = 10734900011,
        move3d = 10734898756,
        movediagonal = 10734899164,
        movediagonal2 = 10734898934,
        movehorizontal = 10734899414,
        movevertical = 10734899821,
        music = 10734905958,
        music2 = 10734900215,
        music3 = 10734905665,
        music4 = 10734905823,
        navigation = 10734906744,
        navigation2 = 10734906332,
        navigation2off = 10734906144,
        navigationoff = 10734906580,
        network = 10734906975,
        newspaper = 10734907168,
        octagon = 10734907361,
        option = 10734907649,
        outdent = 10734907933,
        package = 10734909540,
        package2 = 10734908151,
        packagecheck = 10734908384,
        packageminus = 10734908626,
        packageopen = 10734908793,
        packageplus = 10734909016,
        packagesearch = 10734909196,
        packagex = 10734909375,
        paintbucket = 10734909847,
        paintbrush = 10734910187,
        paintbrush2 = 10734910030,
        palette = 10734910430,
        palmtree = 10734910680,
        paperclip = 10734910927,
        partypopper = 10734918735,
        pause = 10734919336,
        pausecircle = 10735024209,
        pauseoctagon = 10734919143,
        pentool = 10734919503,
        pencil = 10734919691,
        percent = 10734919919,
        personstanding = 10734920149,
        phone = 10734921524,
        phonecall = 10734920305,
        phoneforwarded = 10734920508,
        phoneincoming = 10734920694,
        phonemissed = 10734920845,
        phoneoff = 10734921077,
        phoneoutgoing = 10734921288,
        piechart = 10734921727,
        piggybank = 10734921935,
        pin = 10734922324,
        pinoff = 10734922180,
        pipette = 10734922497,
        pizza = 10734922774,
        plane = 10734922971,
        play = 10734923549,
        playcircle = 10734923214,
        plus = 10734924532,
        pluscircle = 10734923868,
        plussquare = 10734924219,
        podcast = 10734929553,
        pointer = 10734929723,
        poundsterling = 10734929981,
        power = 10734930466,
        poweroff = 10734930257,
        printer = 10734930632,
        puzzle = 10734930886,
        quote = 10734931234,
        radio = 10734931596,
        radioreceiver = 10734931402,
        rectanglehorizontal = 10734931777,
        rectanglevertical = 10734932081,
        recycle = 10734932295,
        redo = 10734932822,
        redo2 = 10734932586,
        refreshccw = 10734933056,
        refreshcw = 10734933222,
        refrigerator = 10734933465,
        regex = 10734933655,
        ["repeat"] = 10734933966,
        repeat1 = 10734933826,
        reply = 10734934252,
        replyall = 10734934132,
        rewind = 10734934347,
        rocket = 10734934585,
        rockingchair = 10734939942,
        rotate3d = 10734940107,
        rotateccw = 10734940376,
        rotatecw = 10734940654,
        rss = 10734940825,
        ruler = 10734941018,
        russianruble = 10734941199,
        sailboat = 10734941354,
        save = 10734941499,
        scale = 10734941912,
        scale3d = 10734941739,
        scaling = 10734942072,
        scan = 10734942565,
        scanface = 10734942198,
        scanline = 10734942351,
        scissors = 10734942778,
        screenshare = 10734943193,
        screenshareoff = 10734942967,
        scroll = 10734943448,
        search = 10734943674,
        send = 10734943902,
        separatorhorizontal = 10734944115,
        separatorvertical = 10734944326,
        server = 10734949856,
        servercog = 10734944444,
        servercrash = 10734944554,
        serveroff = 10734944668,
        settings = 10734950309,
        settings2 = 10734950020,
        share = 10734950813,
        share2 = 10734950553,
        sheet = 10734951038,
        shield = 10734951847,
        shieldalert = 10734951173,
        shieldcheck = 10734951367,
        shieldclose = 10734951535,
        shieldoff = 10734951684,
        shirt = 10734952036,
        shoppingbag = 10734952273,
        shoppingcart = 10734952479,
        shovel = 10734952773,
        showerhead = 10734952942,
        shrink = 10734953073,
        shrub = 10734953241,
        shuffle = 10734953451,
        sidebar = 10734954301,
        sidebarclose = 10734953715,
        sidebaropen = 10734954000,
        sigma = 10734954538,
        signal = 10734961133,
        signalhigh = 10734954807,
        signallow = 10734955080,
        signalmedium = 10734955336,
        signalzero = 10734960878,
        siren = 10734961284,
        skipback = 10734961526,
        skipforward = 10734961809,
        skull = 10734962068,
        slack = 10734962339,
        slash = 10734962600,
        slice = 10734963024,
        sliders = 10734963400,
        slidershorizontal = 10734963191,
        smartphone = 10734963940,
        smartphonecharging = 10734963671,
        smile = 10734964441,
        smileplus = 10734964188,
        snowflake = 10734964600,
        sofa = 10734964852,
        sortasc = 10734965115,
        sortdesc = 10734965287,
        speaker = 10734965419,
        sprout = 10734965572,
        square = 10734965702,
        star = 10734966248,
        starhalf = 10734965897,
        staroff = 10734966097,
        stethoscope = 10734966384,
        sticker = 10734972234,
        stickynote = 10734972463,
        stopcircle = 10734972621,
        stretchhorizontal = 10734972862,
        stretchvertical = 10734973130,
        strikethrough = 10734973290,
        subscript = 10734973457,
        sun = 10734974297,
        sundim = 10734973645,
        sunmedium = 10734973778,
        sunmoon = 10734973999,
        sunsnow = 10734974130,
        sunrise = 10734974522,
        sunset = 10734974689,
        superscript = 10734974850,
        swissfranc = 10734975024,
        switchcamera = 10734975214,
        sword = 10734975486,
        swords = 10734975692,
        syringe = 10734975932,
        table = 10734976230,
        table2 = 10734976097,
        tablet = 10734976394,
        tag = 10734976528,
        tags = 10734976739,
        target = 10734977012,
        tent = 10734981750,
        terminal = 10734982144,
        terminalsquare = 10734981995,
        textcursor = 10734982395,
        textcursorinput = 10734982297,
        thermometer = 10734983134,
        thermometersnowflake = 10734982571,
        thermometersun = 10734982771,
        thumbsdown = 10734983359,
        thumbsup = 10734983629,
        ticket = 10734983868,
        timer = 10734984606,
        timeroff = 10734984138,
        timerreset = 10734984355,
        toggleleft = 10734984834,
        toggleright = 10734985040,
        tornado = 10734985247,
        toybrick = 10747361919,
        train = 10747362105,
        trash = 10747362393,
        trash2 = 10747362241,
        treedeciduous = 10747362534,
        treepine = 10747362748,
        trees = 10747363016,
        trendingdown = 10747363205,
        trendingup = 10747363465,
        triangle = 10747363621,
        trophy = 10747363809,
        truck = 10747364031,
        tv = 10747364593,
        tv2 = 10747364302,
        type = 10747364761,
        umbrella = 10747364971,
        underline = 10747365191,
        undo = 10747365484,
        undo2 = 10747365359,
        unlink = 10747365771,
        unlink2 = 10747397871,
        unlock = 10747366027,
        upload = 10747366434,
        uploadcloud = 10747366266,
        usb = 10747366606,
        user = 10747373176,
        usercheck = 10747371901,
        usercog = 10747372167,
        userminus = 10747372346,
        userplus = 10747372702,
        userx = 10747372992,
        users = 10747373426,
        utensils = 10747373821,
        utensilscrossed = 10747373629,
        venetianmask = 10747374003,
        verified = 10747374131,
        vibrate = 10747374489,
        vibrateoff = 10747374269,
        video = 10747374938,
        videooff = 10747374721,
        view = 10747375132,
        voicemail = 10747375281,
        volume = 10747376008,
        volume1 = 10747375450,
        volume2 = 10747375679,
        volumex = 10747375880,
        wallet = 10747376205,
        wand = 10747376565,
        wand2 = 10747376349,
        watch = 10747376722,
        waves = 10747376931,
        webcam = 10747381992,
        wifi = 10747382504,
        wifioff = 10747382268,
        wind = 10747382750,
        wraptext = 10747383065,
        wrench = 10747383470,
        x = 10747384394,
        xcircle = 10747383819,
        xoctagon = 10747384037,
        xsquare = 10747384217,
        zoomin = 10747384552,
        zoomout = 10747384679
}

-- > {INTENÇÃO}
-- Organizar e limpar o código de gerenciamento de temas da UI
-- - Remover comentários excessivos ou "anormais"
-- - Usar comentários claros, concisos e bem estruturados
-- - Melhorar legibilidade e facilitar manutenção futura
-- - Manter a funcionalidade idêntica

-----------------------------------------------------------------------
-- Tabela de Constantes de Design (Tema Dark Clean com alto contraste)
-----------------------------------------------------------------------
local DESIGN = {
	-- Cores principais
	WindowColor1          = Color3.fromRGB(25, 26, 28),
	WindowColor2          = Color3.fromRGB(20, 21, 23),
	BlockScreenColor      = Color3.fromRGB(0, 0, 0, 0.65),
	WindowTransparency    = 0.4,
	TabContainerTransparency = 0.15,

	TitleColor            = Color3.fromRGB(240, 240, 245),
	ComponentTextColor    = Color3.fromRGB(215, 215, 220),
	InputTextColor        = Color3.fromRGB(230, 230, 235),
	NotifyTextColor       = Color3.fromRGB(220, 220, 225),
	EmptyStateTextColor   = Color3.fromRGB(150, 150, 155),

	ComponentBackground   = Color3.fromRGB(34, 35, 38),
	InputBackgroundColor  = Color3.fromRGB(42, 43, 47),

	AccentColor           = Color3.fromRGB(90, 160, 255),
	ItemHoverColor        = Color3.fromRGB(50, 52, 57),
	ComponentHoverColor   = Color3.fromRGB(65, 68, 75),

	ActiveToggleColor     = Color3.fromRGB(90, 160, 255),
	InactiveToggleColor   = Color3.fromRGB(55, 56, 60),

	MinimizeButtonColor   = Color3.fromRGB(180, 180, 185),
	CloseButtonColor      = Color3.fromRGB(255, 85, 100),
	FloatButtonColor      = Color3.fromRGB(45, 46, 52),

	DropdownBackground    = Color3.fromRGB(32, 33, 37),
	DropdownItemHover     = Color3.fromRGB(55, 57, 63),

	TabActiveColor        = Color3.fromRGB(90, 160, 255),
	TabInactiveColor      = Color3.fromRGB(36, 37, 41),

	SliderTrackColor      = Color3.fromRGB(58, 59, 63),
	SliderFillColor       = Color3.fromRGB(90, 160, 255),
	ThumbColor            = Color3.fromRGB(240, 240, 245),
	ThumbOutlineColor     = Color3.fromRGB(45, 46, 50),

	HRColor               = Color3.fromRGB(75, 76, 82),
	ResizeHandleColor     = Color3.fromRGB(60, 61, 66),
	NotifyBackground      = Color3.fromRGB(38, 39, 43),
	TagBackground         = Color3.fromRGB(90, 160, 255),

	-- Dimensões e layout (otimizadas para telas menores)
	WindowSize            = UDim2.new(0, 450, 0, 300),
	MinWindowSize         = Vector2.new(320, 260),
	MaxWindowSize         = Vector2.new(520, 370),

	TitleHeight           = 32,
	TitlePadding          = 10,

	ComponentHeight       = 32,
	ComponentPadding      = 6,
	ContainerPadding      = 5,
	CornerRadius          = 6,

	ButtonIconSize        = 20,
	IconSize              = 24,

	TabButtonWidth        = 110,
	TabButtonHeight       = 36,

	FloatButtonSize       = UDim2.new(0, 130, 0, 42),
	ResizeHandleSize      = 14,

	NotifyWidth           = 250,
	NotifyHeight          = 65,
	TagHeight             = 28,
	TagWidth              = 100,

	HRHeight              = 1,
	HRTextPadding         = 10,
	HRMinTextSize         = 16,
	HRMaxTextSize         = 24,

	DropdownWidth         = 140,
	DropdownItemHeight    = 32,

	BlurEffectSize        = 8,
	AnimationSpeed        = 0.2,
}

-- Armazena objetos que dependem de cada chave do tema para atualização dinâmica
local THEME_BINDINGS = {}

-- > {UTILITÁRIO}
-- Cópia superficial de tabela (usada para criar presets independentes)
local function ShallowCopy(original: table): table
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

-- > {REGISTRO DE COMPONENTES}
-- Registra um objeto UI para ser atualizado automaticamente quando a chave do tema mudar
local function RegisterThemeItem(key: string, object: Instance, property: string)
	if not THEME_BINDINGS[key] then
		THEME_BINDINGS[key] = {}
	end

	table.insert(THEME_BINDINGS[key], { object = object, property = property })

	-- Aplica valor inicial se já existir no DESIGN
	if DESIGN[key] ~= nil then
		object[property] = DESIGN[key]
	end
end

-- > {ATUALIZAÇÃO DINÂMICA}
-- Aplica uma nova cor/dimensão a todos os objetos registrados para a chave
local function ApplyThemeChange(key: string, newValue: any)
	DESIGN[key] = newValue

	if THEME_BINDINGS[key] then
		for _, data in ipairs(THEME_BINDINGS[key]) do
			if data.object and data.object.Parent then
				data.object[data.property] = newValue
			end
		end
	end
end

-- Atualiza uma chave específica do tema (com validação)
local function SetThemeKey(key: string, value: any)
	if DESIGN[key] == nil then
		warn("[Theme] Chave inexistente no DESIGN:", key)
		return
	end
	ApplyThemeChange(key, value)
end

-- > {PRESETS DE TEMAS}
local PRESETS = {
	Default = ShallowCopy(DESIGN),

	Oceanic = {
		WindowColor1          = Color3.fromRGB(18, 24, 32),
		WindowColor2          = Color3.fromRGB(13, 18, 25),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0),
		WindowTransparency    = 0.1,
		TabContainerTransparency = 0.12,

		TitleColor            = Color3.fromRGB(220, 235, 245),
		ComponentTextColor    = Color3.fromRGB(210, 225, 235),
		InputTextColor        = Color3.fromRGB(225, 235, 240),
		NotifyTextColor       = Color3.fromRGB(215, 230, 240),
		EmptyStateTextColor   = Color3.fromRGB(150, 170, 175),

		ComponentBackground   = Color3.fromRGB(26, 34, 44),
		InputBackgroundColor  = Color3.fromRGB(30, 38, 50),

		AccentColor           = Color3.fromRGB(42, 160, 200),
		ItemHoverColor        = Color3.fromRGB(34, 44, 57),
		ComponentHoverColor   = Color3.fromRGB(40, 52, 68),

		ActiveToggleColor     = Color3.fromRGB(42, 160, 200),
		InactiveToggleColor   = Color3.fromRGB(60, 66, 74),

		MinimizeButtonColor   = Color3.fromRGB(185, 190, 195),
		CloseButtonColor      = Color3.fromRGB(230, 90, 90),
		FloatButtonColor      = Color3.fromRGB(28, 34, 42),

		DropdownBackground    = Color3.fromRGB(24, 32, 42),
		DropdownItemHover     = Color3.fromRGB(36, 46, 60),

		TabActiveColor        = Color3.fromRGB(42, 160, 200),
		TabInactiveColor      = Color3.fromRGB(38, 44, 50),

		SliderTrackColor      = Color3.fromRGB(52, 60, 70),
		SliderFillColor       = Color3.fromRGB(42, 160, 200),
		ThumbColor            = Color3.fromRGB(235, 245, 250),
		ThumbOutlineColor     = Color3.fromRGB(48, 56, 64),

		HRColor               = Color3.fromRGB(64, 76, 90),
		ResizeHandleColor     = Color3.fromRGB(56, 62, 70),
		NotifyBackground      = Color3.fromRGB(26, 34, 44),
		TagBackground         = Color3.fromRGB(42, 160, 200),
	},

	Slate = {
		WindowColor1          = Color3.fromRGB(28, 30, 34),
		WindowColor2          = Color3.fromRGB(22, 24, 28),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0),
		WindowTransparency    = 0.12,
		TabContainerTransparency = 0.16,

		TitleColor            = Color3.fromRGB(235, 238, 240),
		ComponentTextColor    = Color3.fromRGB(220, 224, 226),
		InputTextColor        = Color3.fromRGB(230, 233, 235),
		NotifyTextColor       = Color3.fromRGB(225, 228, 230),
		EmptyStateTextColor   = Color3.fromRGB(155, 160, 165),

		ComponentBackground   = Color3.fromRGB(36, 38, 42),
		InputBackgroundColor  = Color3.fromRGB(42, 44, 48),

		AccentColor           = Color3.fromRGB(84, 185, 150),
		ItemHoverColor        = Color3.fromRGB(46, 48, 52),
		ComponentHoverColor   = Color3.fromRGB(52, 56, 60),

		ActiveToggleColor     = Color3.fromRGB(84, 185, 150),
		InactiveToggleColor   = Color3.fromRGB(64, 66, 70),

		MinimizeButtonColor   = Color3.fromRGB(190, 190, 195),
		CloseButtonColor      = Color3.fromRGB(255, 95, 95),
		FloatButtonColor      = Color3.fromRGB(34, 36, 40),

		DropdownBackground    = Color3.fromRGB(32, 34, 38),
		DropdownItemHover     = Color3.fromRGB(48, 50, 54),

		TabActiveColor        = Color3.fromRGB(84, 185, 150),
		TabInactiveColor      = Color3.fromRGB(40, 42, 46),

		SliderTrackColor      = Color3.fromRGB(58, 60, 64),
		SliderFillColor       = Color3.fromRGB(84, 185, 150),
		ThumbColor            = Color3.fromRGB(244, 246, 246),
		ThumbOutlineColor     = Color3.fromRGB(50, 52, 56),

		HRColor               = Color3.fromRGB(80, 84, 88),
		ResizeHandleColor     = Color3.fromRGB(60, 62, 66),
		NotifyBackground      = Color3.fromRGB(34, 36, 40),
		TagBackground         = Color3.fromRGB(84, 185, 150),
	},

	MonoDark = {
		WindowColor1          = Color3.fromRGB(30, 30, 30),
		WindowColor2          = Color3.fromRGB(20, 20, 20),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0, 0.6),
		WindowTransparency    = 0.1,
		TabContainerTransparency = 0.15,

		TitleColor            = Color3.fromRGB(255, 255, 255),
		ComponentTextColor    = Color3.fromRGB(210, 210, 210),
		InputTextColor        = Color3.fromRGB(230, 230, 230),
		NotifyTextColor       = Color3.fromRGB(220, 220, 220),
		EmptyStateTextColor   = Color3.fromRGB(140, 140, 140),

		ComponentBackground   = Color3.fromRGB(40, 40, 40),
		InputBackgroundColor  = Color3.fromRGB(50, 50, 50),

		AccentColor           = Color3.fromRGB(255, 255, 255),
		ItemHoverColor        = Color3.fromRGB(60, 60, 60),
		ComponentHoverColor   = Color3.fromRGB(75, 75, 75),

		ActiveToggleColor     = Color3.fromRGB(255, 255, 255),
		InactiveToggleColor   = Color3.fromRGB(60, 60, 60),

		MinimizeButtonColor   = Color3.fromRGB(180, 180, 180),
		CloseButtonColor      = Color3.fromRGB(255, 80, 80),
		FloatButtonColor      = Color3.fromRGB(35, 35, 35),

		DropdownBackground    = Color3.fromRGB(30, 30, 30),
		DropdownItemHover     = Color3.fromRGB(55, 55, 55),

		TabActiveColor        = Color3.fromRGB(255, 255, 255),
		TabInactiveColor      = Color3.fromRGB(45, 45, 45),

		SliderTrackColor      = Color3.fromRGB(70, 70, 70),
		SliderFillColor       = Color3.fromRGB(255, 255, 255),
		ThumbColor            = Color3.fromRGB(255, 255, 255),
		ThumbOutlineColor     = Color3.fromRGB(50, 50, 50),

		HRColor               = Color3.fromRGB(85, 85, 85),
		ResizeHandleColor     = Color3.fromRGB(65, 65, 65),
		NotifyBackground      = Color3.fromRGB(45, 45, 45),
		TagBackground         = Color3.fromRGB(255, 255, 255),
	},

	Forest = {
		WindowColor1          = Color3.fromRGB(20, 28, 20),
		WindowColor2          = Color3.fromRGB(15, 22, 15),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0, 0.7),
		WindowTransparency    = 0.5,
		TabContainerTransparency = 0.10,

		TitleColor            = Color3.fromRGB(230, 245, 230),
		ComponentTextColor    = Color3.fromRGB(200, 220, 200),
		InputTextColor        = Color3.fromRGB(210, 230, 210),
		NotifyTextColor       = Color3.fromRGB(205, 225, 205),
		EmptyStateTextColor   = Color3.fromRGB(130, 160, 130),

		ComponentBackground   = Color3.fromRGB(30, 42, 30),
		InputBackgroundColor  = Color3.fromRGB(40, 55, 40),

		AccentColor           = Color3.fromRGB(100, 170, 100),
		ItemHoverColor        = Color3.fromRGB(40, 55, 40),
		ComponentHoverColor   = Color3.fromRGB(50, 70, 50),

		ActiveToggleColor     = Color3.fromRGB(100, 170, 100),
		InactiveToggleColor   = Color3.fromRGB(50, 65, 50),

		MinimizeButtonColor   = Color3.fromRGB(170, 190, 170),
		CloseButtonColor      = Color3.fromRGB(255, 90, 90),
		FloatButtonColor      = Color3.fromRGB(25, 35, 25),

		DropdownBackground    = Color3.fromRGB(20, 30, 20),
		DropdownItemHover     = Color3.fromRGB(45, 60, 45),

		TabActiveColor        = Color3.fromRGB(100, 170, 100),
		TabInactiveColor      = Color3.fromRGB(35, 45, 35),

		SliderTrackColor      = Color3.fromRGB(60, 80, 60),
		SliderFillColor       = Color3.fromRGB(100, 170, 100),
		ThumbColor            = Color3.fromRGB(230, 245, 230),
		ThumbOutlineColor     = Color3.fromRGB(50, 65, 50),

		HRColor               = Color3.fromRGB(75, 100, 75),
		ResizeHandleColor     = Color3.fromRGB(60, 80, 60),
		NotifyBackground      = Color3.fromRGB(35, 45, 35),
		TagBackground         = Color3.fromRGB(100, 170, 100),
	},

	CrimsonDusk = {
		WindowColor1          = Color3.fromRGB(15, 17, 21),
		WindowColor2          = Color3.fromRGB(10, 12, 15),
		BlockScreenColor      = Color3.fromRGB(0, 0, 0, 0.7),
		WindowTransparency    = 0.1,
		TabContainerTransparency = 0.15,

		TitleColor            = Color3.fromRGB(250, 250, 255),
		ComponentTextColor    = Color3.fromRGB(220, 225, 230),
		InputTextColor        = Color3.fromRGB(240, 240, 245),
		NotifyTextColor       = Color3.fromRGB(230, 235, 240),
		EmptyStateTextColor   = Color3.fromRGB(130, 140, 150),

		ComponentBackground   = Color3.fromRGB(24, 28, 34),
		InputBackgroundColor  = Color3.fromRGB(30, 35, 42),

		AccentColor           = Color3.fromRGB(220, 50, 80),
		ItemHoverColor        = Color3.fromRGB(35, 40, 50),
		ComponentHoverColor   = Color3.fromRGB(45, 50, 60),

		ActiveToggleColor     = Color3.fromRGB(220, 50, 80),
		InactiveToggleColor   = Color3.fromRGB(45, 50, 58),

		MinimizeButtonColor   = Color3.fromRGB(190, 195, 200),
		CloseButtonColor      = Color3.fromRGB(255, 80, 80),
		FloatButtonColor      = Color3.fromRGB(20, 23, 28),

		DropdownBackground    = Color3.fromRGB(20, 22, 26),
		DropdownItemHover     = Color3.fromRGB(40, 45, 55),

		TabActiveColor        = Color3.fromRGB(220, 50, 80),
		TabInactiveColor      = Color3.fromRGB(30, 34, 40),

		SliderTrackColor      = Color3.fromRGB(50, 55, 65),
		SliderFillColor       = Color3.fromRGB(220, 50, 80),
		ThumbColor            = Color3.fromRGB(250, 250, 255),
		ThumbOutlineColor     = Color3.fromRGB(40, 45, 52),

		HRColor               = Color3.fromRGB(70, 80, 95),
		ResizeHandleColor     = Color3.fromRGB(60, 70, 85),
		NotifyBackground      = Color3.fromRGB(24, 28, 34),
		TagBackground         = Color3.fromRGB(220, 50, 80),
	},
}

-- > {APLICAÇÃO DE TEMA}
-- Aplica um preset completo, atualizando apenas as chaves que mudaram
local function SetTheme(presetTable: table)
	if type(presetTable) ~= "table" then
		warn("[Theme] Preset inválido fornecido para SetTheme")
		return
	end

	for key, value in pairs(presetTable) do
		if DESIGN[key] ~= nil and DESIGN[key] ~= value then
			ApplyThemeChange(key, value)
		end
	end
end

-- > {UTILITÁRIO EXTRA}
-- Retorna uma string JSON com a lista de nomes de temas disponíveis (ordenada)
local function GetAvailableThemesJson(): string
	local themeNames = {}
	for name, _ in pairs(PRESETS) do
		table.insert(themeNames, name)
	end

	table.sort(themeNames)
	return '[\"' .. table.concat(themeNames, '\",\"') .. '\"]'
end

-- Tema inicial aplicado ao carregar o módulo
SetTheme(PRESETS.Oceanic)
---
-- Funções de Criação de Componentes
---

-- cache de TweenInfo (evita recriar o mesmo objeto várias vezes)
local tweenInfo = TweenInfo.new(DESIGN.AnimationSpeed, Enum.EasingStyle.Quad)

-- utilitário para criar cantos arredondados (reutilizável e limpo)
local function addRoundedCorners(instance: Instance, radius: number?)
	if not instance or not instance:IsA("GuiObject") then return end

	local corner = instance:FindFirstChildOfClass("UICorner")
	if not corner then
		corner = Instance.new("UICorner")
		corner.Name = "Corner"
		corner.Parent = instance
	end

	corner.CornerRadius = UDim.new(0, radius or DESIGN.CornerRadius)
	return corner
end

-- efeito de hover otimizado e com cleanup
local function addHoverEffect(button: GuiObject, originalColor: Color3, hoverColor: Color3, condition: (() -> boolean)?)
	if not button or not button:IsA("GuiObject") then return end

	local isHovering, isDown = false, false
	local activeTween

	local function safeTween(targetColor)
		if activeTween then
			activeTween:Cancel()
			activeTween = nil
		end
		if not condition or condition() then
			activeTween = TweenService:Create(button, tweenInfo, { BackgroundColor3 = targetColor })
			activeTween:Play()
		end
	end

	-- Conexões armazenadas para facilitar desconexão no Destroy
	local connections = {}

	table.insert(connections, button.MouseEnter:Connect(function()
		isHovering = true
		if not isDown then safeTween(hoverColor) end
	end))

	table.insert(connections, button.MouseLeave:Connect(function()
		isHovering = false
		if not isDown then safeTween(originalColor) end
	end))

	table.insert(connections, button.MouseButton1Down:Connect(function()
		isDown = true
	end))

	table.insert(connections, button.MouseButton1Up:Connect(function()
		isDown = false
		if not isHovering then safeTween(originalColor) end
	end))

	-- Cleanup automático ao destruir o botão
	button.AncestryChanged:Connect(function(_, parent)
		if not parent then
			for _, conn in ipairs(connections) do
				conn:Disconnect()
			end
			connections = {}
			activeTween = nil
		end
	end)
end

-- criação do botão
local function createButton(text: string, size: UDim2?, parent: Instance)
	local btn = Instance.new("TextButton")
	btn.Text = text
	btn.Size = size or UDim2.new(1, 0, 0, DESIGN.ComponentHeight)
	btn.BackgroundColor3 = DESIGN.ComponentBackground
	btn.TextColor3 = DESIGN.ComponentTextColor
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.Roboto
	btn.TextScaled = true
	btn.AutoButtonColor = false -- desativa o hover padrão
	btn.Parent = parent

	addRoundedCorners(btn, DESIGN.CornerRadius)
	addHoverEffect(btn, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)

	return btn
end

local Tab = {}
Tab.__index = Tab

-- > Construtor de uma aba individual
function Tab.new(name: string, parent: Instance)
    local self = setmetatable({}, Tab)

    self.Name = name
    self.Components = {}
    self._connections = {}

    -- > Cria o container principal (ScrollingFrame) da aba
    self:_CreateContainer(parent)

    -- > Configura o overlay e box de estado vazio
    self:_SetupEmptyState()

    -- > Configura reaplicação de cores do tema para elementos da aba
    self:_SetupThemeReapplication()

    -- > Controle automático de visibilidade do empty state e scrollbar
    self:_SetupVisibilityControl()

    return self
end

-- > Cria o ScrollingFrame principal da aba
function Tab:_CreateContainer(parent)
    local container = Instance.new("ScrollingFrame")
    self.Container = container
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 6
    container.ScrollBarImageColor3 = DESIGN.ComponentHoverColor
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.ScrollingDirection = Enum.ScrollingDirection.Y
    container.ClipsDescendants = true
    container.Parent = parent

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, DESIGN.ContainerPadding)
    padding.PaddingLeft = UDim.new(0, DESIGN.ContainerPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ContainerPadding)
    padding.PaddingBottom = UDim.new(0, DESIGN.ContainerPadding)
    padding.Parent = container

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, DESIGN.ComponentPadding)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = container
    self._listLayout = listLayout
end

-- > Configura o overlay com box de "aba vazia"
function Tab:_SetupEmptyState()
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 5
    overlay.Parent = self.Container
    self._overlay = overlay

    local emptyBox = Instance.new("Frame")
    self.EmptyBox = emptyBox
    emptyBox.Size = UDim2.new(0.6, 0, 0.2, 0)
    emptyBox.AnchorPoint = Vector2.new(0.5, 0.5)
    emptyBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    emptyBox.BackgroundColor3 = DESIGN.EmptyStateBoxColor or Color3.fromRGB(30, 30, 30)
    emptyBox.BackgroundTransparency = 0.2
    emptyBox.BorderSizePixel = 0
    emptyBox.Visible = true
    emptyBox.ZIndex = 6
    emptyBox.Parent = overlay

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius or 10)
    corner.Parent = emptyBox

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = DESIGN.EmptyStateBorderColor or Color3.fromRGB(80, 80, 80)
    stroke.Transparency = 0.3
    stroke.Parent = emptyBox
    self._emptyStroke = stroke

    local emptyText = Instance.new("TextLabel")
    self.EmptyText = emptyText
    emptyText.Size = UDim2.new(1, -10, 1, -10)
    emptyText.AnchorPoint = Vector2.new(0.5, 0.5)
    emptyText.Position = UDim2.new(0.5, 0, 0.5, 0)
    emptyText.BackgroundTransparency = 1
    emptyText.Text = "Parece que ainda não há nada aqui."
    emptyText.TextColor3 = DESIGN.EmptyStateTextColor or Color3.fromRGB(180, 180, 180)
    emptyText.Font = Enum.Font.Roboto
    emptyText.TextScaled = true
    emptyText.TextWrapped = true
    emptyText.ZIndex = 7
    emptyText.Parent = emptyBox

    RegisterThemeItem("EmptyStateTextColor", emptyText, "TextColor3")
end

-- > Configura reaplicação de cores específicas da aba
function Tab:_SetupThemeReapplication()
    function self:_reapplyScrollAndEmptyColors()
        self.Container.ScrollBarImageColor3 = DESIGN.ComponentHoverColor
        self.EmptyBox.BackgroundColor3 = DESIGN.EmptyStateBoxColor or Color3.fromRGB(30, 30, 30)
        if self._emptyStroke then
            self._emptyStroke.Color = DESIGN.EmptyStateBorderColor or Color3.fromRGB(80, 80, 80)
        end
    end

    RegisterThemeItem("ComponentHoverColor", self, "_reapplyScrollAndEmptyColors")
    RegisterThemeItem("EmptyStateBoxColor", self, "_reapplyScrollAndEmptyColors")
    RegisterThemeItem("EmptyStateBorderColor", self, "_reapplyScrollAndEmptyColors")
end

-- > Controla visibilidade do empty state e transparência da scrollbar
function Tab:_SetupVisibilityControl()
    self._listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local hasComponents = #self.Components > 0
        self._overlay.Visible = not hasComponents

        local totalContentHeight = self._listLayout.AbsoluteContentSize.Y + (DESIGN.ContainerPadding * 2)
        local containerHeight = self.Container.AbsoluteSize.Y
        self.Container.ScrollBarImageTransparency = totalContentHeight > containerHeight and 0 or 1
    end)
end

-- > Cria uma nova aba e configura botão + lógica de ativação
function Tekscripts:CreateTab(options: { Title: string })
    local title = assert(options.Title, "CreateTab: argumento 'Title' inválido")
    assert(type(title) == "string", "CreateTab: argumento 'Title' deve ser string")

    local tab = Tab.new(title, self.TabContentContainer)
    tab._parentRef = self
    self.Tabs[title] = tab

    -- > Cria o botão da aba no container lateral
    tab:_CreateTabButton(self)

    -- > Define aba inicial se necessário
    if (self.startTab == title) or not self.CurrentTab then
        self:SetActiveTab(tab)
    end

    -- > Atualiza label de "sem abas"
    self.NoTabsLabel.Visible = next(self.Tabs) == nil

    -- > Método Destroy da aba
    function tab:Destroy()
        if self._destroyed then return end
        self._destroyed = true

        self._parentRef = nil

        for _, conn in ipairs(self._connections or {}) do
            if conn.Connected then conn:Disconnect() end
        end
        self._connections = {}

        for _, comp in pairs(self.Components or {}) do
            if typeof(comp) == "table" and comp.Destroy then
                comp:Destroy()
            end
        end
        self.Components = {}

        if self.Container then self.Container:Destroy() end
        if self.Button then self.Button:Destroy() end

        if self._parentRef and self._parentRef.Tabs then
            self._parentRef.Tabs[title] = nil

            if self._parentRef.CurrentTab == self then
                local nextKey = next(self._parentRef.Tabs)
                local nextTab = nextKey and self._parentRef.Tabs[nextKey]

                self._parentRef.CurrentTab = nextTab
                self._parentRef.NoTabsLabel.Visible = nextTab == nil

                if nextTab then
                    self._parentRef:SetActiveTab(nextTab)
                end
            end
        end

        table.clear(self)
    end

    return tab
end

-- > Cria e configura o botão visual da aba
function Tab:_CreateTabButton(parentWindow)
    local button = Instance.new("TextButton")
    self.Button = button
    button.Name = self.Name
    button.Text = self.Name
    button.Size = UDim2.new(1, 0, 0, DESIGN.TabButtonHeight)
    button.TextColor3 = DESIGN.ComponentTextColor
    button.BackgroundColor3 = DESIGN.TabInactiveColor
    button.Font = Enum.Font.Roboto
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.ZIndex = 3
    button.Parent = parentWindow.TabContainer

    RegisterThemeItem("ComponentTextColor", button, "TextColor3")
    addRoundedCorners(button, DESIGN.CornerRadius)

    addHoverEffect(button, DESIGN.TabInactiveColor, DESIGN.ComponentHoverColor, function()
        return parentWindow.CurrentTab ~= self
    end)

    table.insert(self._connections, button.MouseButton1Click:Connect(function()
        if not parentWindow.Blocked then
            parentWindow:SetActiveTab(self)
        end
    end))

    table.insert(self._connections, button.AncestryChanged:Connect(function(_, p)
        if not p and not self._destroyed then
            self:Destroy()
        end
    end))

    self.Container.Visible = false
end

-- > Ativa uma aba específica (lazy visibility)
function Tekscripts:SetActiveTab(tab)
    if self.CurrentTab and self.CurrentTab ~= tab then
        self.CurrentTab.Container.Visible = false
        self.CurrentTab.Button.BackgroundColor3 = DESIGN.TabInactiveColor
    end

    self.CurrentTab = tab
    if tab then
        tab.Container.Visible = true
        tab.Button.BackgroundColor3 = DESIGN.TabActiveColor
    end
end

-- > Construtor principal da janela Tekscripts (mantido como antes, já refatorado)
-- > Construtor principal da janela Tekscripts
function Tekscripts.new(options: { 
    Name: string?, 
    Parent: Instance?, 
    FloatText: string?, 
    startTab: string?, 
    iconId: string?, 
    Transparent: boolean?, 
    TabContainerTransparency: number?, 
    WindowTransparency: number?,
    LoadScreen: boolean?,       
    Loading: table?             
})
    options = options or {}
    
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    -- > Configuração inicial de transparência baseada nas opções do usuário
    local useThemeTransparency = options.Transparent == true
    local windowTransparency = useThemeTransparency 
        and (options.WindowTransparency or DESIGN.WindowTransparency) 
        or DESIGN.WindowTransparency or 0.1
    local tabContainerTransparency = useThemeTransparency 
        and (options.TabContainerTransparency or DESIGN.TabContainerTransparency) 
        or DESIGN.TabContainerTransparency or 0.1

    -- > Detecção de dispositivo móvel para escala responsiva
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local responsiveScale = isMobile and 0.85 or 1.0

    -- > Criação do objeto principal com estado inicial
    local self = setmetatable({
        ScreenGui = nil,
        Window = nil,
        TitleBar = nil,
        TabContainer = nil,
        TabContentContainer = nil,
        ResizeHandle = nil,
        FloatButton = nil,
        EdgeButtons = {},
        Connections = {},
        BlockScreen = nil,
        Blocked = false,
        MinimizedState = nil,
        Tabs = {},
        CurrentTab = nil,
        IsDragging = false,
        IsResizing = false,
        
        CloseButtonContainer = nil,
        CloseButton = nil,
        NoTabsLabel = nil,
        Title = nil,
        BlurEffect = nil,
        
        startTab = options.startTab,
        
        _useThemeTransparency = useThemeTransparency,
        _userWindowTransparency = options.WindowTransparency,
        _userTabContainerTransparency = options.TabContainerTransparency,
    }, Tekscripts)

    -- > Criação do ScreenGui base
    self:_CreateScreenGui(options, localPlayer)

    -- > Cálculo do tamanho e posição final da janela
    local finalWindowSize = self:_GetWindowSize()
    local finalWindowPos = self:_GetWindowPosition()
    local finalAnchorPoint = self._isSmallScreen and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)

    -- > Verifica se deve iniciar com loading screen
    local isLoading = options.LoadScreen == true and options.Loading ~= nil

    -- > Criação da janela principal com tamanho inicial adequado
    self:_CreateMainWindow(isLoading, finalWindowSize, finalWindowPos, finalAnchorPoint, responsiveScale, windowTransparency)

    -- > Configuração da barra de título completa
    self:_SetupTitleBar(isLoading, options, responsiveScale, tabContainerTransparency)

    -- > Configuração do dropdown de fechar (••• → Fechar)
    self:_SetupCloseDropdown()

    -- > Configuração dos containers de abas e conteúdo
    self:_SetupTabContainers(tabContainerTransparency, windowTransparency, isLoading)

    -- > Componentes adicionais (resize, float button, block screen)
    self:_SetupAdditionalComponents(options.FloatText or "Expandir")

    -- > Sistema de reaplicação de tema
    self:_SetupThemeReapplication()

    -- > Conexão para destruir a UI ao sair do jogo
    self.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        if player == localPlayer then
            self:Destroy()
        end
    end)

    -- > Inicialização do loading screen, se ativado
    if isLoading then
        self:_SetupLoadingScreen(options.Loading, finalWindowSize, finalWindowPos, finalAnchorPoint)
    end

    return self
end

-- > Cria o ScreenGui e define propriedades básicas
function Tekscripts:_CreateScreenGui(options, localPlayer)
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = options.Name or "Tekscripts"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = options.Parent or localPlayer:WaitForChild("PlayerGui")
end

-- > Cria a janela principal (Frame) com gradiente e escala
function Tekscripts:_CreateMainWindow(isLoading, finalSize, finalPos, finalAnchor, scale, transparency)
    self.Window = Instance.new("Frame")
    
    if isLoading then
        self.Window.Size = UDim2.new(0, 280 * scale, 0, 120 * scale)
        self.Window.Position = UDim2.new(0.5, 0, 0.5, 0)
        self.Window.AnchorPoint = Vector2.new(0.5, 0.5)
    else
        self.Window.Size = finalSize
        self.Window.Position = finalPos
        self.Window.AnchorPoint = finalAnchor
    end

    self.Window.BackgroundColor3 = DESIGN.WindowColor1
    self.Window.BackgroundTransparency = transparency
    self.Window.BorderSizePixel = 0
    self.Window.ClipsDescendants = true
    self.Window.Parent = self.ScreenGui

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = scale
    uiScale.Parent = self.Window

    addRoundedCorners(self.Window, DESIGN.CornerRadius)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(DESIGN.WindowColor1, DESIGN.WindowColor2)
    gradient.Rotation = 90
    gradient.Parent = self.Window
    self._windowGradient = gradient  -- guardado para uso no reapply
end

-- > Configura toda a barra de título (ícone, título, botões)
function Tekscripts:_SetupTitleBar(isLoading, options, scale, transparency)
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, DESIGN.TitleHeight)
    self.TitleBar.BackgroundColor3 = DESIGN.WindowColor2
    self.TitleBar.BackgroundTransparency = transparency
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Visible = not isLoading
    self.TitleBar.Parent = self.Window

    addRoundedCorners(self.TitleBar, DESIGN.CornerRadius)
    RegisterThemeItem("WindowColor2", self.TitleBar, "BackgroundColor3")

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 1, 0)
    header.BackgroundTransparency = 1
    header.Parent = self.TitleBar

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = header

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = header

    -- Ícone opcional
    local iconSize = 0
    if options.iconId then
        iconSize = DESIGN.IconSize
        local iconFrame = Instance.new("Frame")
        iconFrame.Size = UDim2.new(0, iconSize, 0, iconSize)
        iconFrame.BackgroundTransparency = 1
        iconFrame.ClipsDescendants = true
        iconFrame.Parent = header

        local icon = Instance.new("ImageLabel")
        icon.Image = options.iconId
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Parent = iconFrame

        addRoundedCorners(iconFrame, 5)
    end

    -- Título
    local titleOffset = iconSize + (iconSize > 0 and 5 or 0) + (DESIGN.TitleHeight * 2) + DESIGN.TitlePadding
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -titleOffset, 1, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.ClipsDescendants = true
    titleFrame.Parent = header

    local title = Instance.new("TextLabel")
    self.Title = title
    title.Name = "Title"
    title.Text = options.Name or "Tekscripts"
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = DESIGN.TitleColor
    title.Font = Enum.Font.RobotoMono
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleFrame
    RegisterThemeItem("TitleColor", title, "TextColor3")

    self:SetupTitleScroll()

    -- Botões de controle
    self:_SetupTitleBarButtons(header)
    self:SetupDragSystem()
end

-- > Cria os botões da barra de título (••• e minimizar)
function Tekscripts:_SetupTitleBarButtons(parent)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0, DESIGN.TitleHeight * 2, 1, 0)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Padding = UDim.new(0, 5)
    layout.Parent = buttonFrame

    -- Botão de menu
    local controlBtn = Instance.new("TextButton")
    controlBtn.Name = "ControlBtn"
    controlBtn.Text = "•••"
    controlBtn.Size = UDim2.new(0, DESIGN.TitleHeight, 0, DESIGN.TitleHeight)
    controlBtn.BackgroundColor3 = DESIGN.ComponentBackground
    controlBtn.TextColor3 = DESIGN.ComponentTextColor
    controlBtn.Font = Enum.Font.Roboto
    controlBtn.TextScaled = true
    controlBtn.BorderSizePixel = 0
    controlBtn.Parent = buttonFrame
    RegisterThemeItem("ComponentBackground", controlBtn, "BackgroundColor3")
    RegisterThemeItem("ComponentTextColor", controlBtn, "TextColor3")
    addRoundedCorners(controlBtn, DESIGN.CornerRadius)
    addHoverEffect(controlBtn, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)
    self._controlBtn = controlBtn

    -- Botão minimizar
    local minimizeBtn = Instance.new("ImageButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, DESIGN.TitleHeight, 0, DESIGN.TitleHeight)
    minimizeBtn.BackgroundColor3 = DESIGN.MinimizeButtonColor
    minimizeBtn.Image = "rbxassetid://10734895698"
    minimizeBtn.ScaleType = Enum.ScaleType.Fit
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = buttonFrame
    RegisterThemeItem("MinimizeButtonColor", minimizeBtn, "BackgroundColor3")
    addRoundedCorners(minimizeBtn, DESIGN.CornerRadius)
    addHoverEffect(minimizeBtn, DESIGN.MinimizeButtonColor, DESIGN.ComponentHoverColor)

    self.Connections.MinimizeClick = minimizeBtn.MouseButton1Click:Connect(function()
        self:Minimize()
        self:HideCloseButton()
    end)
end

-- > Configura o dropdown de fechar
function Tekscripts:_SetupCloseDropdown()
    self.CloseButtonContainer = Instance.new("Frame")
    local width = DESIGN.DropdownWidth or 100
    local height = DESIGN.DropdownItemHeight or 25
    self.CloseButtonContainer.Size = UDim2.new(0, width + 10, 0, height + 10)
    self.CloseButtonContainer.BackgroundColor3 = DESIGN.DropdownBackground
    self.CloseButtonContainer.BackgroundTransparency = DESIGN.DropdownTransparency or 0
    self.CloseButtonContainer.BorderSizePixel = 0
    self.CloseButtonContainer.Visible = false
    self.CloseButtonContainer.ZIndex = 10
    self.CloseButtonContainer.Parent = self.Window
    addRoundedCorners(self.CloseButtonContainer)

    local closeBtn = Instance.new("TextButton")
    self.CloseButton = closeBtn
    closeBtn.Text = "Fechar"
    closeBtn.Size = UDim2.new(1, -10, 1, -10)
    closeBtn.Position = UDim2.new(0, 5, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.TextColor3 = DESIGN.CloseButtonColor
    closeBtn.Font = Enum.Font.Roboto
    closeBtn.TextScaled = true
    closeBtn.ZIndex = 11
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = self.CloseButtonContainer
    RegisterThemeItem("CloseButtonColor", closeBtn, "TextColor3")
    addRoundedCorners(closeBtn, 5)
    addHoverEffect(closeBtn, DESIGN.DropdownBackground, DESIGN.DropdownItemHover)

    self.Connections.CloseClick = closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    -- Toggle e posicionamento do dropdown
    self.Connections.ControlBtn = self._controlBtn.MouseButton1Click:Connect(function()
        local visible = not self.CloseButtonContainer.Visible
        self.CloseButtonContainer.Visible = visible
        if visible then
            local absCtrl = self._controlBtn.AbsolutePosition
            local absWin = self.Window.AbsolutePosition
            local size = self.CloseButtonContainer.AbsoluteSize
            local x = absCtrl.X - absWin.X + self._controlBtn.AbsoluteSize.X - size.X
            self.CloseButtonContainer.Position = UDim2.new(0, x, 0, DESIGN.TitleHeight + 2)
        end
    end)

    -- Fechar ao clicar fora
    self.Connections.InputBegan = game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
        if gp or not self.CloseButtonContainer.Visible then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = game:GetService("UserInputService"):GetMouseLocation()
            local dropPos = self.CloseButtonContainer.AbsolutePosition
            local dropSize = self.CloseButtonContainer.AbsoluteSize
            local ctrlPos = self._controlBtn.AbsolutePosition
            local ctrlSize = self._controlBtn.AbsoluteSize

            local outsideDrop = mouse.X < dropPos.X or mouse.X > dropPos.X + dropSize.X
                or mouse.Y < dropPos.Y or mouse.Y > dropPos.Y + dropSize.Y
            local outsideCtrl = mouse.X < ctrlPos.X or mouse.X > ctrlPos.X + ctrlSize.X
                or mouse.Y < ctrlPos.Y or mouse.Y > ctrlPos.Y + ctrlSize.Y

            if outsideDrop and outsideCtrl then
                self.CloseButtonContainer.Visible = false
            end
        end
    end)
end

-- > Configura containers de abas e conteúdo principal
function Tekscripts:_SetupTabContainers(tabTransparency, winTransparency, isLoading)
    local tabSize = self:_GetTabContainerSize()

    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(tabSize.X.Scale, tabSize.X.Offset, 1, -DESIGN.TitleHeight)
    self.TabContainer.Position = UDim2.new(0, 0, 0, DESIGN.TitleHeight)
    self.TabContainer.BackgroundColor3 = DESIGN.WindowColor2
    self.TabContainer.BackgroundTransparency = tabTransparency
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Visible = not isLoading
    self.TabContainer.Parent = self.Window
    RegisterThemeItem("WindowColor2", self.TabContainer, "BackgroundColor3")
    addRoundedCorners(self.TabContainer, DESIGN.CornerRadius)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = self.TabContainer

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = self.TabContainer

    -- Estado vazio
    self.NoTabsLabel = Instance.new("TextLabel")
    self.NoTabsLabel.Size = UDim2.new(1, 0, 1, 0)
    self.NoTabsLabel.BackgroundTransparency = 1
    self.NoTabsLabel.Text = "nada ainda"
    self.NoTabsLabel.TextColor3 = DESIGN.EmptyStateTextColor
    self.NoTabsLabel.Font = Enum.Font.Roboto
    self.NoTabsLabel.TextScaled = true
    self.NoTabsLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.NoTabsLabel.Parent = self.TabContainer
    RegisterThemeItem("EmptyStateTextColor", self.NoTabsLabel, "TextColor3")

    -- Conteúdo das abas
    self.TabContentContainer = Instance.new("Frame")
    self.TabContentContainer.Size = UDim2.new(1 - tabSize.X.Scale, -tabSize.X.Offset, 1, -DESIGN.TitleHeight)
    self.TabContentContainer.Position = UDim2.new(tabSize.X.Scale, tabSize.X.Offset, 0, DESIGN.TitleHeight)
    self.TabContentContainer.BackgroundColor3 = DESIGN.WindowColor1
    self.TabContentContainer.BackgroundTransparency = winTransparency
    self.TabContentContainer.BorderSizePixel = 0
    self.TabContentContainer.Visible = not isLoading
    self.TabContentContainer.Parent = self.Window
end

-- > Configura resize, float button e tela de bloqueio
function Tekscripts:_SetupAdditionalComponents(floatText)
    self:SetupResizeSystem()
    self:SetupFloatButton(floatText)

    self.BlockScreen = Instance.new("Frame")
    self.BlockScreen.Size = UDim2.new(1, 0, 1, 0)
    self.BlockScreen.BackgroundColor3 = DESIGN.BlockScreenColor
    self.BlockScreen.BackgroundTransparency = 0.5
    self.BlockScreen.ZIndex = 10
    self.BlockScreen.Visible = false
    self.BlockScreen.Parent = self.ScreenGui
    RegisterThemeItem("BlockScreenColor", self.BlockScreen, "BackgroundColor3")

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = self.BlockScreen
    self.BlurEffect = blur
end

-- > Configura o sistema de reaplicação de tema
function Tekscripts:_SetupThemeReapplication()
    function self:_reapplyThemeColors()
        local winTransp = self._useThemeTransparency and (self._userWindowTransparency or DESIGN.WindowTransparency) or DESIGN.WindowTransparency or 0.1
        local tabTransp = self._useThemeTransparency and (self._userTabContainerTransparency or DESIGN.TabContainerTransparency) or DESIGN.TabContainerTransparency or 0.1

        self.Window.BackgroundColor3 = DESIGN.WindowColor1
        self.Window.BackgroundTransparency = winTransp
        self._windowGradient.Color = ColorSequence.new(DESIGN.WindowColor1, DESIGN.WindowColor2)

        self.TitleBar.BackgroundColor3 = DESIGN.WindowColor2
        self.TitleBar.BackgroundTransparency = tabTransp
        self.Title.TextColor3 = DESIGN.TitleColor

        self.TabContainer.BackgroundColor3 = DESIGN.WindowColor2
        self.TabContainer.BackgroundTransparency = tabTransp
        self.TabContentContainer.BackgroundColor3 = DESIGN.WindowColor1
        self.TabContentContainer.BackgroundTransparency = winTransp

        self._controlBtn.BackgroundColor3 = DESIGN.ComponentBackground
        self._controlBtn.TextColor3 = DESIGN.ComponentTextColor
        addHoverEffect(self._controlBtn, DESIGN.ComponentBackground, DESIGN.ComponentHoverColor)

        self.CloseButtonContainer.BackgroundColor3 = DESIGN.DropdownBackground
        self.CloseButtonContainer.BackgroundTransparency = DESIGN.DropdownTransparency or 0
        self.CloseButton.TextColor3 = DESIGN.CloseButtonColor
        addHoverEffect(self.CloseButton, DESIGN.DropdownBackground, DESIGN.DropdownItemHover)

        self.NoTabsLabel.TextColor3 = DESIGN.EmptyStateTextColor
        self.BlockScreen.BackgroundColor3 = DESIGN.BlockScreenColor

        if self.ResizeHandle and self.ResizeHandle._reapplyThemeColors then
            self.ResizeHandle:_reapplyThemeColors()
        end
        if self.FloatButton and self.FloatButton._reapplyThemeColors then
            self.FloatButton:_reapplyThemeColors()
        end
    end

    local keys = {
        "WindowColor1", "WindowColor2", "WindowTransparency", "TabContainerTransparency",
        "TitleColor", "ComponentBackground", "ComponentTextColor", "ComponentHoverColor",
        "MinimizeButtonColor", "DropdownBackground", "DropdownTransparency",
        "CloseButtonColor", "DropdownItemHover", "EmptyStateTextColor", "BlockScreenColor"
    }
    for _, key in ipairs(keys) do
        RegisterThemeItem(key, self, "_reapplyThemeColors")
    end
end

-- > Configura e executa a animação do loading screen
function Tekscripts:_SetupLoadingScreen(config, finalSize, finalPos, finalAnchor)
    self.Blocked = true

    local content = Instance.new("Frame")
    content.Name = "LoadingContent"
    content.Size = UDim2.new(1, -40, 1, -40)
    content.Position = UDim2.new(0, 20, 0, 20)
    content.BackgroundTransparency = 1
    content.Parent = self.Window

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0, 2)
    layout.Parent = content

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "Carregando"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 19
    title.TextColor3 = DESIGN.TitleColor or Color3.fromRGB(255, 255, 255)
    title.Size = UDim2.new(1, 0, 0, 24)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = content

    local desc = Instance.new("TextLabel")
    desc.Text = config.Desc or "Aguarde..."
    desc.Font = Enum.Font.SourceSans
    desc.TextSize = 13
    desc.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(160, 160, 160)
    desc.Size = UDim2.new(1, 0, 0, 18)
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.BackgroundTransparency = 1
    desc.TextWrapped = true
    desc.Parent = content

    local spinner = Instance.new("Frame")
    spinner.Name = "MinimalSpinner"
    spinner.Size = UDim2.new(0, 16, 0, 16)
    spinner.Position = UDim2.new(1, -15, 1, -15)
    spinner.AnchorPoint = Vector2.new(1, 1)
    spinner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    spinner.Parent = self.Window
    addRoundedCorners(spinner, UDim.new(1, 0))

    local grad = Instance.new("UIGradient")
    grad.Transparency = NumberSequence.new(0, 0, 0.8, 1, 1, 1)
    grad.Color = ColorSequence.new(DESIGN.ComponentHoverColor or Color3.fromRGB(0, 170, 255))
    grad.Parent = spinner

    task.spawn(function()
        local tween = game:GetService("TweenService"):Create(spinner, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
        tween:Play()

        task.wait(2.5)

        local fade = TweenInfo.new(0.4)
        game:GetService("TweenService"):Create(title, fade, {TextTransparency = 1}):Play()
        game:GetService("TweenService"):Create(desc, fade, {TextTransparency = 1}):Play()
        game:GetService("TweenService"):Create(spinner, fade, {BackgroundTransparency = 1}):Play()

        task.wait(0.4)
        content:Destroy()
        spinner:Destroy()

        local expand = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local expandTween = game:GetService("TweenService"):Create(self.Window, expand, {
            Size = finalSize,
            Position = finalPos,
            AnchorPoint = finalAnchor
        })
        expandTween:Play()
        expandTween.Completed:Wait()

        self.TitleBar.Visible = true
        self.TabContainer.Visible = true
        self.TabContentContainer.Visible = true
        self.Blocked = false
    end)
end
-- Necessário que esta função exista no módulo principal (Tekscripts) para funcionar corretamente.
function Tekscripts:HideCloseButton()
    if self.CloseButtonContainer and self.CloseButtonContainer.Parent then
        self.CloseButtonContainer.Visible = false
    end
end

-- Certifique-se de que a função :Destroy() está configurada para limpar corretamente.
-- Exemplo de como :Destroy() deve ser (incluindo a nova chamada):
function Tekscripts:Destroy()
    -- 1. Desliga o botão de fechar individualmente.
    self:HideCloseButton() 
    
    -- 2. Limpa o ScreenGui e conexões (supondo que o restante da sua lógica faça isso)
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end


function Tekscripts:_UpdateScreenSize()
    self._viewSize = workspace.CurrentCamera.ViewportSize
    self._isSmallScreen = self._viewSize.X < DESIGN.MinWindowSize.X
end

function Tekscripts:_GetWindowSize()
    return self._isSmallScreen and UDim2.new(0.95, 0, 0.95, 0) or DESIGN.WindowSize
end

function Tekscripts:_GetWindowPosition()
    if self._isSmallScreen then
        return UDim2.new(0.5, 0, 0.5, 0)
    else
        local size = DESIGN.WindowSize
        return UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
    end
end

function Tekscripts:_GetTabContainerSize()
    -- Tamanho da aba lateral (o offset é o que determina a largura fixa do painel de abas)
    return self._isSmallScreen and UDim2.new(0.3, 0, 1, -DESIGN.TitleHeight) or UDim2.new(0, DESIGN.TabButtonWidth, 1, -DESIGN.TitleHeight)
end

-- **CORREÇÃO: Esta função será simplificada, pois a lógica real de preenchimento será feita em UpdateContainersSize.**
-- Deixamos ela retornar apenas o valor padrão ou o que for necessário para cálculo inicial, mas o UpdateContainersSize terá a lógica de fill.
function Tekscripts:_GetContentContainerSize()
    -- NOTA: Este valor não é mais usado diretamente para cálculo de tamanho, apenas para a estrutura inicial.
    -- A lógica de redimensionamento é feita no UpdateContainersSize.
    local tabWidth = self._isSmallScreen and UDim.new(0.3, 0) or UDim.new(0, DESIGN.TabButtonWidth)
    local remainingScale = 1 - tabWidth.Scale
    local remainingOffset = -tabWidth.Offset
    
    return UDim2.new(remainingScale, remainingOffset, 1, -DESIGN.TitleHeight)
end

function Tekscripts:Destroy()
    if self.TitleScrollConnection then
        self.TitleScrollConnection:Disconnect()
        self.TitleScrollConnection = nil
    end
    if self.TitleScrollTween then
        self.TitleScrollTween:Cancel()
        self.TitleScrollTween = nil
    end
    if self._activeTween then
        self._activeTween:Cancel()
        self._activeTween = nil
    end
    for _, buttonData in pairs(self.EdgeButtons) do
        if buttonData.Frame then
            buttonData.Frame:Destroy()
        end
    end
    self.EdgeButtons = {}
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
    for _, connection in pairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    self.Connections = {}
    for _, tab in pairs(self.Tabs) do
        if tab.Destroy then
            tab:Destroy()
        end
    end
    self.Tabs = {}
    setmetatable(self, nil)
end

---
-- NOVO: Sistema de rolagem de título (otimizado para não criar tweens desnecessários)
---
function Tekscripts:SetupTitleScroll()
    local title = self.Title
    local parent = title.Parent
    if not title or not parent then return end

    local isScrolling = false

    local function checkAndScroll()
        local textWidth = title.TextBounds.X
        local parentWidth = parent.AbsoluteSize.X
        if textWidth <= parentWidth then
            if isScrolling then
                if self.TitleScrollTween then
                    self.TitleScrollTween:Cancel()
                    self.TitleScrollTween = nil
                end
                title.Position = UDim2.new(0, 0, 0, 0)
                isScrolling = false
            end
            return
        end

        if not isScrolling then
            isScrolling = true
            local scrollDistance = textWidth - parentWidth + 5
            local scrollTime = scrollDistance / 50

            local tweenInfo = TweenInfo.new(
                scrollTime,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut,
                -1,
                false,
                0
            )

            self.TitleScrollTween = TweenService:Create(title, tweenInfo, { Position = UDim2.new(0, -scrollDistance, 0, 0) })
            self.TitleScrollTween:Play()
        end
    end

    self.TitleScrollConnection = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(checkAndScroll)
    title:GetPropertyChangedSignal("TextBounds"):Connect(checkAndScroll)

    -- Verificação inicial
    checkAndScroll()
end

---
-- Sistema de Arrastar (otimizado: atualização direta, sem tweens por input)
---
function Tekscripts:SetupDragSystem()
    local UIS = game:GetService("UserInputService")

    self.Connections.DragBegin = self.TitleBar.InputBegan:Connect(function(input)
        if self.Blocked or self.MinimizedState then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            
            self.IsDragging = true

            local pos = Vector2.new(input.Position.X, input.Position.Y)

            -- Pega o offset correto (dedo - posição da janela)
            local absPos = self.Window.AbsolutePosition
            self._offset = Vector2.new(pos.X - absPos.X, pos.Y - absPos.Y)
        end
    end)

    self.Connections.DragChanged = UIS.InputChanged:Connect(function(input)
        if not self.IsDragging or self.Blocked or self.MinimizedState then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            
            local pos = Vector2.new(input.Position.X, input.Position.Y)

            -- Nova posição = dedo - offset
            local newX = pos.X - self._offset.X
            local newY = pos.Y - self._offset.Y

            self.Window.Position = UDim2.fromOffset(newX, newY)
        end
    end)

    self.Connections.DragEnded = UIS.InputEnded:Connect(function(input)
        if not self.IsDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            
            self.IsDragging = false

            if not self.MinimizedState then
            end
        end
    end)
end

---
-- Sistema de Redimensionamento (atualização direta)
---
function Tekscripts:SetupResizeSystem()
    local GripVisualSize = 30  -- tamanho do frame pai (só pra organizar)

    -- ==================== GRIP VISUAL (agora fica FORA do painel, na borda externa) ====================
    local ResizeGrip = Instance.new("Frame")
    ResizeGrip.Name = "ResizeGripVisual"
    ResizeGrip.Size = UDim2.new(0, GripVisualSize, 0, GripVisualSize)
    ResizeGrip.Position = UDim2.new(1, -12, 1, -12)  -- começa um pouco pra dentro só pra ancorar
    ResizeGrip.BackgroundTransparency = 1
    ResizeGrip.ClipsDescendants = false  -- ESSENCIAL pra linhas saírem pra fora
    ResizeGrip.ZIndex = 10
    ResizeGrip.Parent = self.Window
    self.ResizeHandle = ResizeGrip

    -- Cria as 3 linhas que tocam a borda externa (igual WindUI)
    local function createLine(offset)
        local line = Instance.new("Frame")
        line.BackgroundColor3 = DESIGN.ResizeHandleColor or Color3.fromRGB(160, 160, 160)
        line.BorderSizePixel = 0
        line.Size = UDim2.new(0, 14, 0, 2)
        line.AnchorPoint = Vector2.new(1, 1)
        line.Position = UDim2.new(1, 2 + offset * -7, 1, 2 + offset * -7)  -- sai pra fora com valores positivos aqui + anchor 1,1
        line.Rotation = 45
        line.BackgroundTransparency = 1
        line.ZIndex = 10
        line.Parent = ResizeGrip
        return line
    end

    local line1 = createLine(0)  -- a mais externa (toca na borda)
    local line2 = createLine(1)
    local line3 = createLine(2)  -- a mais interna

    -- Animação de hover
    local function setHover(hovering)
        local target = hovering and 0 or 1
        local tween = TweenService:Create(line1, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = target})
        TweenService:Create(line2, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = target}):Play()
        TweenService:Create(line3, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = target}):Play()
        tween:Play()
    end

    -- ==================== HITBOX (área de clique grande) ====================
    local Hitbox = Instance.new("Frame")
    Hitbox.Name = "ResizeHitbox"
    Hitbox.Size = UDim2.new(0, 40, 0, 40)
    Hitbox.Position = UDim2.new(1, -40, 1, -40)
    Hitbox.BackgroundTransparency = 1
    Hitbox.ZIndex = 10
    Hitbox.Parent = self.Window

    -- Hover + cursor
    self.Connections.ResizeMouseEnter = Hitbox.MouseEnter:Connect(function()
        setHover(true)
        UserInputService.MouseIcon = "rbxassetid://6258410714"
    end)

    self.Connections.ResizeMouseLeave = Hitbox.MouseLeave:Connect(function()
        setHover(false)
        if not self.IsDragging and not self.IsResizing then
            UserInputService.MouseIcon = ""
        end
    end)

    -- ==================== REDIMENSIONAMENTO ====================
    self.Connections.ResizeBegin = Hitbox.InputBegan:Connect(function(input)
        if self.Blocked or input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        self.IsResizing = true
        self._resizeStart = input.Position
        self._startSize = self.Window.Size
    end)

    self.Connections.ResizeChanged = UserInputService.InputChanged:Connect(function(input)
        if not self.IsResizing or self.Blocked then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - self._resizeStart
        local screen = workspace.CurrentCamera.ViewportSize
        local maxW = math.min(DESIGN.MaxWindowSize.X, screen.X * 0.9)
        local maxH = math.min(DESIGN.MaxWindowSize.Y, screen.Y * 0.9)

        local newW = math.clamp(self._startSize.X.Offset + delta.X, DESIGN.MinWindowSize.X, maxW)
        local newH = math.clamp(self._startSize.Y.Offset + delta.Y, DESIGN.MinWindowSize.Y, maxH)

        self.Window.Size = UDim2.new(0, newW, 0, newH)
        self:UpdateContainersSize()
    end)

    self.Connections.ResizeEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.IsResizing = false
            if not self.IsDragging then UserInputService.MouseIcon = "" end
            setHover(false)
        end
    end)
end

-- **CORREÇÃO PRINCIPAL: Lógica de ajuste de layout durante o redimensionamento**
function Tekscripts:UpdateContainersSize()
    -- 1. Recalcula o tamanho ideal da aba (TabContainer)
    local tabContainerSize = self:_GetTabContainerSize()

    if self.TabContainer then
        -- A altura é sempre 100% da área abaixo da TitleBar
        self.TabContainer.Size = UDim2.new(tabContainerSize.X.Scale, tabContainerSize.X.Offset, 1, -DESIGN.TitleHeight)
        self.TabContainer.Position = UDim2.new(0, 0, 0, DESIGN.TitleHeight)
    end

    if self.TabContentContainer then
        -- 2. Calcula a posição X do conteúdo (onde a aba termina)
        local tabContainerXScale = tabContainerSize.X.Scale
        local tabContainerXOffset = tabContainerSize.X.Offset
        
        -- 3. Calcula o tamanho X do conteúdo para PREENCHER o espaço restante.
        -- Tamanho X = (1 - Escala da aba), (- Offset da aba)
        local contentSizeX = UDim.new(1 - tabContainerXScale, -tabContainerXOffset)
        
        -- Aplica a nova posição e tamanho
        self.TabContentContainer.Position = UDim2.new(tabContainerXScale, tabContainerXOffset, 0, DESIGN.TitleHeight)
        self.TabContentContainer.Size = UDim2.new(contentSizeX.Scale, contentSizeX.Offset, 1, -DESIGN.TitleHeight)
    end

    -- Grip visual sempre encostado na borda externa
    if self.ResizeHandle then
        self.ResizeHandle.Position = UDim2.new(1, -12, 1, -12)
    end

    -- Hitbox sempre no canto
    local hitbox = self.Window:FindFirstChild("ResizeHitbox")
    if hitbox then
        hitbox.Position = UDim2.new(1, -40, 1, -40)
    end
end

---
-- Float Button (otimizado)
---
local FALLBACK_ICON_ID = 10723424838 -- ID Padrão para fallback

--- NOVA FUNÇÃO: EDITA OS ATRIBUTOS DO BOTÃO FLUTUANTE JÁ EXISTENTE
function Tekscripts:FloatButtonEdit(options: {Text: string?, Icon: string?})
    -- Verifica se o botão flutuante existe antes de tentar editar
    local float = self.FloatButton
    if not float or not float:IsA("Frame") then
        warn("Tekscripts:FloatButtonEdit: FloatButton não encontrado. Certifique-se de que SetupFloatButton foi chamado primeiro.")
        return
    end

    local actionBtn = float:FindFirstChild("ActionButton")
    local dragBtn = float:FindFirstChild("DragButton")

    -- 1. Edição do Texto (Text)
    if options.Text and actionBtn and actionBtn:IsA("TextButton") then
        actionBtn.Text = options.Text
    end

    -- 2. Edição do Ícone (Icon)
    if options.Icon and dragBtn and dragBtn:IsA("ImageButton") then
        local iconName = options.Icon
        local assetId = icones[iconName]
        
        local iconAssetId = "rbxassetid://" .. tostring(FALLBACK_ICON_ID) -- Ícone padrão/fallback
        
        if assetId then
            -- Se o nome do ícone for válido, usa o ID correspondente
            iconAssetId = "rbxassetid://" .. tostring(assetId)
        end
        
        dragBtn.Image = iconAssetId
    end
end
----------------------------------------------------------------------------------------------------

-- FUNÇÃO ORIGINAL: CRIAÇÃO DO BOTÃO FLUTUANTE
function Tekscripts:SetupFloatButton(text: string, icon: string?)
    local UIS = game:GetService("UserInputService")
    
    -- Frame principal
    local float = Instance.new("Frame")
    float.Name = "FloatButton"
    float.Size = UDim2.new(0, 180, 0, 45)
    float.Position = UDim2.new(1, -200, 0, 20)
    float.BackgroundColor3 = DESIGN.FloatButtonColor
    float.BorderSizePixel = 0
    float.Visible = false
    float.Parent = self.ScreenGui
    self.FloatButton = float -- Armazena a referência principal

    addRoundedCorners(float, DESIGN.CornerRadius)

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(DESIGN.FloatButtonColor, DESIGN.WindowColor2)
    grad.Rotation = 45
    grad.Parent = float

    -- BOTÃO DE ARRASTAR (esquerda)
    local dragBtn = Instance.new("ImageButton")
    dragBtn.Name = "DragButton"
    dragBtn.Size = UDim2.new(0, 45, 1, 0)
    dragBtn.Position = UDim2.new(0, 0, 0, 0)
    dragBtn.BackgroundColor3 = DESIGN.FloatButtonColor
    dragBtn.BorderSizePixel = 0
    dragBtn.ScaleType = Enum.ScaleType.Fit
    dragBtn.Parent = float

    -- LÓGICA PARA DEFINIR O ÍCONE INICIAL:
    local iconAssetId = "rbxassetid://" .. tostring(FALLBACK_ICON_ID) 
    
    if icon and icones[icon] then 
        iconAssetId = "rbxassetid://" .. tostring(icones[icon])
    end
    
    dragBtn.Image = iconAssetId 

    addHoverEffect(dragBtn, nil, DESIGN.ComponentHoverColor)

    -- BOTÃO DE AÇÃO (texto - abre painel)
    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = "ActionButton" -- Importante para o FloatButtonEdit
    actionBtn.Size = UDim2.new(1, -45, 1, 0)
    actionBtn.Position = UDim2.new(0, 45, 0, 0)
    actionBtn.BackgroundTransparency = 1
    actionBtn.Text = text
    actionBtn.Font = Enum.Font.Roboto
    actionBtn.TextScaled = true
    actionBtn.TextColor3 = DESIGN.ComponentTextColor
    actionBtn.Parent = float

    addHoverEffect(actionBtn, nil, DESIGN.ComponentHoverColor)

    -- Abre painel ao clicar no texto
    self.Connections.FloatExpand = actionBtn.MouseButton1Click:Connect(function()
        if not self.Blocked then
            self:ExpandFromFloat()
        end
    end)

    -- SISTEMA DE DRAG (O restante do código de drag permanece inalterado)
    local dragging = false
    local dragStart
    local startPos

    self.Connections.FloatBegin = dragBtn.InputBegan:Connect(function(input)
        if self.Blocked then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1 
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = UIS:GetMouseLocation()
            startPos = float.Position
        end
    end)

    self.Connections.FloatChange = UIS.InputChanged:Connect(function(input)
        if not dragging or self.Blocked then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement 
        or input.UserInputType == Enum.UserInputType.Touch then
            
            local delta = UIS:GetMouseLocation() - dragStart

            float.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    self.Connections.FloatEnd = UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

---
-- Funções de Estado (Minimizar/Expandir) otimizadas
---

function Tekscripts:Minimize()
if self.Blocked or self.MinimizedState then return end

self.MinimizedState = "float"
self.LastWindowPosition = self.Window.Position
self.LastWindowSize = self.Window.Size

if self._activeTween then self._activeTween:Cancel() end

local minimizeTween = TweenService:Create(self.Window, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0)
})

self._activeTween = minimizeTween

minimizeTween.Completed:Once(function()
    self.Window.Visible = false
    self.FloatButton.Visible = true
    self._activeTween = TweenService:Create(self.FloatButton, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = DESIGN.FloatButtonSize
    })
    self._activeTween:Play()
    self._activeTween.Completed:Once(function()
        self._activeTween = nil
    end)
end)

minimizeTween:Play()
end

function Tekscripts:ExpandFromFloat()
if self.MinimizedState ~= "float" or self.Blocked then return end

if self._activeTween then self._activeTween:Cancel() end

local floatTween = TweenService:Create(self.FloatButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
    Size = UDim2.new(0, 0, 0, 0)
})

self._activeTween = floatTween

floatTween.Completed:Once(function()
    self.FloatButton.Visible = false
    self.Window.Visible = true
    self._activeTween = nil

    local screenSize = workspace.CurrentCamera.ViewportSize
    local windowW = math.min(DESIGN.WindowSize.X.Offset, screenSize.X * 0.8)
    local windowH = math.min(DESIGN.WindowSize.Y.Offset, screenSize.Y * 0.8)
    
    local newPos = UDim2.new(0.5, -windowW/2, 0.5, -windowH/2)
    
    local expandTween = TweenService:Create(self.Window, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, windowW, 0, windowH),
        Position = newPos
    })
    
    self._activeTween = expandTween
    expandTween:Play()
    
    expandTween.Completed:Once(function()
        self.MinimizedState = nil
        self._activeTween = nil
    end)
end)

floatTween:Play()
end


function Tekscripts:Block(state: boolean)
    self.Blocked = state
    self.BlockScreen.Visible = state
    local targetSize = state and DESIGN.BlurEffectSize or 0
    TweenService:Create(self.BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
end
---
-- Funções Públicas para criar componentes
---
-- 🟩 API COPY

-- 🔹 Copiar texto universalmente
function Tekscripts:Copy(text: string)
	assert(type(text) == "string", "O texto precisa ser uma string")

	local success, msg = false, ""

	-- 1️⃣ Exploits comuns
	if typeof(setclipboard) == "function" then
		pcall(setclipboard, text)
		success, msg = true, "[Clipboard] Copiado com setclipboard."

	elseif typeof(toclipboard) == "function" then
		pcall(toclipboard, text)
		success, msg = true, "[Clipboard] Copiado com toclipboard."

	-- 2️⃣ Roblox Studio (plugin dev)
	elseif plugin and typeof(plugin.SetClipboard) == "function" then
		pcall(function()
			plugin:SetClipboard(text)
			success = true
			msg = "[Clipboard] Copiado com plugin:SetClipboard."
		end)

	-- 3️⃣ getgenv() fallback
	elseif rawget(getgenv and getgenv() or {}, "setclipboard") then
		pcall(getgenv().setclipboard, text)
		success, msg = true, "[Clipboard] Copiado via getgenv().setclipboard."

	else
		msg = "[Clipboard] Nenhuma API de cópia disponível neste ambiente."
	end

	if success then
		print(msg)
	else
		warn(msg .. " Texto: " .. text)
	end

	return success
end


-- 🔹 Copiar path de instância automaticamente
function Tekscripts:CopyInstancePath(instance: Instance)
	assert(typeof(instance) == "Instance", "O argumento precisa ser uma instância válida")
	local path = instance:GetFullName()
	return self:Copy(path)
end
-- 🟩 FIM API COPY

-- 🟩 API DIRECTORY
function Tekscripts:WriteFile(path: string, content: string)
	assert(type(path) == "string", "Caminho inválido")
	assert(type(content) == "string", "Conteúdo inválido")

	local writeFunc =
		writefile
		or (fluxus and fluxus.writefile)
		or (trigon and trigon.writeFile)
		or (codex and codex.writefile)
		or (syn and syn.write_file)
		or (KRNL and KRNL.WriteFile)

	if not writeFunc then
		warn("[FS] Executor não suporta escrita de arquivos")
		return false
	end

	local ok, err = pcall(writeFunc, path, content)
	if not ok then warn("[FS] Erro ao escrever arquivo:", err) end
	return ok
end

function Tekscripts:ReadFile(path: string)
	assert(type(path) == "string", "Caminho inválido")

	local readFunc =
		readfile
		or (fluxus and fluxus.readFile)
		or (trigon and trigon.readFile)
		or (codex and codex.readFile)
		or (syn and syn.read_file)
		or (KRNL and KRNL.ReadFile)

	local existsFunc =
		isfile
		or (fluxus and fluxus.isfile)
		or (trigon and trigon.isfile)
		or (codex and codex.isfile)
		or (syn and syn.file_exists)
		or (KRNL and KRNL.IsFile)
		or function() return false end

	if not readFunc or not existsFunc(path) then
		warn("[FS] Arquivo não existe ou leitura não suportada")
		return nil
	end

	local ok, result = pcall(readFunc, path)
	if ok then
		return result
	else
		warn("[FS] Erro ao ler arquivo:", result)
		return nil
	end
end

function Tekscripts:IsFile(path: string)
	assert(type(path) == "string", "Caminho inválido")

	local existsFunc =
		isfile
		or (fluxus and fluxus.isfile)
		or (trigon and trigon.isfile)
		or (codex and codex.isfile)
		or (syn and syn.file_exists)
		or (KRNL and KRNL.IsFile)
		or function() return false end

	return existsFunc(path)
end

-- 🟩 FIM API DIRECTORY

-- 🟩 API REQUEST
function Tekscripts:Request(options)
    assert(type(options) == "table", "As opções precisam ser uma tabela.")
    local HttpService = game:GetService("HttpService")

    local requestFunc = (syn and syn.request) or 
                        (fluxus and fluxus.request) or 
                        (http and http.request) or 
                        (krnl and krnl.request) or 
                        (getgenv() and getgenv().request) or 
                        request

    if not requestFunc then
        warn("[Tekscripts] Executor sem suporte a HTTP.")
        return nil
    end

    -- Encode automático do Body (se você enviar uma tabela para o servidor)
    if options.Body and type(options.Body) == "table" then
        options.Headers = options.Headers or {}
        options.Headers["Content-Type"] = "application/json"
        options.Body = HttpService:JSONEncode(options.Body)
    end

    local ok, response = pcall(requestFunc, options)
    
    if ok and type(response) == "table" then
        -- Retorna SEMPRE o conteúdo bruto (Body) como string
        -- Isso evita que o Lua retorne a tabela da memória
        return tostring(response.Body or "")
    end

    warn("[Tekscripts] Erro na requisição.")
    return nil
end

-- 🟩 FIM DA API REQUEST

function Tekscripts:CreateSlider(tab: any, options: {
    Text: string?,
    Min: number?,
    Max: number?,
    Step: number?,
    Value: number?,
    Callback: ((number) -> ())?
})
    assert(tab and tab.Container, "Invalid Tab object provided to CreateSlider")

    options = options or {}
    local title = options.Text or "Slider"
    local minv = tonumber(options.Min) or 0
    local maxv = tonumber(options.Max) or 100
    local step = tonumber(options.Step) or 1
    local value = tonumber(options.Value) or minv
    local callback = options.Callback

    local function clamp(n)
        return math.max(minv, math.min(maxv, n))
    end

    local function roundToStep(n)
        if step <= 0 then return n end
        return math.floor(n / step + 0.5) * step
    end

    value = clamp(roundToStep(value))

    -- Serviços
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    
    -- Configurações de animação
    local ANIM = {
        ThumbHover = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        ThumbPress = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        ValueChange = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        FillChange = TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
    }

    -- Base visual
    local box = Instance.new("Frame")
    -- MUDANÇA: Altura removida (DESIGN.ComponentHeight) e definido como AutomaticSize.Y
    box.Size = UDim2.new(1, 0, 0, 0)
    box.AutomaticSize = Enum.AutomaticSize.Y -- O box se ajusta à altura do seu conteúdo
    RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
    box.BackgroundColor3 = DESIGN.ComponentBackground
    box.BackgroundTransparency = DESIGN.TabContainerTransparency
    box.BorderSizePixel = 0
    box.Parent = tab.Container

    Instance.new("UICorner", box).CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    
    -- Sombra (Elemento não-temático: mantemos o padrão)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.92
    shadow.ZIndex = 0
    shadow.Parent = box
    
    local padding = Instance.new("UIPadding", box)
    -- Ajuste do Padding: Adicionamos padding Vertical para espaçar o conteúdo das bordas superior/inferior
    padding.PaddingTop = UDim.new(0, DESIGN.ComponentPadding) 
    padding.PaddingBottom = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)

    local container = Instance.new("Frame")
    -- MUDANÇA: Altura deve ser 0 para que o UIListLayout dentro dele defina o tamanho.
    container.Size = UDim2.new(1, 0, 1, 0) -- Tamanho Y 1,0, pois o box tem AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = box

    local listLayout = Instance.new("UIListLayout", container)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 6) -- Espaço entre o Header e o Track/Badge
    -- MUDANÇA: O container também precisa de AutomaticSize para se ajustar ao UIListLayout
    container.AutomaticSize = Enum.AutomaticSize.Y 

    -- Header (Apenas o Título)
    local headerFrame = Instance.new("Frame")
    -- Tamanho fixo em Y para acomodar o TextLabel
    headerFrame.Size = UDim2.new(1, 0, 0, 20)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = container

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    -- O título agora ocupa 100% da largura, pois o valor foi movido
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 14
    RegisterThemeItem("ComponentTextColor", titleLabel, "TextColor3")
    titleLabel.TextColor3 = DESIGN.ComponentTextColor
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.Parent = headerFrame

    -- Track Container (Onde fica a barra do slider e o valor)
    local trackContainer = Instance.new("Frame")
    -- Altura fixa para acomodar a barra de 6px + thumb de 20px (a maior dimensão em Y define a altura necessária)
    trackContainer.Size = UDim2.new(1, 0, 0, 22) -- Mantemos 22 para a badge
    trackContainer.BackgroundTransparency = 1
    trackContainer.Parent = container
    
    -- Layout para colocar a barra e o valor lado a lado
    local listLayoutTrack = Instance.new("UIListLayout", trackContainer)
    listLayoutTrack.FillDirection = Enum.FillDirection.Horizontal
    listLayoutTrack.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayoutTrack.Padding = UDim.new(0, 8) -- Espaço entre o slider e o valor
    listLayoutTrack.SortOrder = Enum.SortOrder.LayoutOrder

    -- Frame para o Slider (Ocupa o espaço restante)
    local sliderFrame = Instance.new("Frame")
    -- 100% menos o tamanho do valueBadge (65px) e o padding (8px) = 100% - 73px
    sliderFrame.Size = UDim2.new(1, -73, 1, 0)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = trackContainer
    sliderFrame.LayoutOrder = 1 -- Primeiro elemento

    -- Track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.AnchorPoint = Vector2.new(0, 0.5)
    track.Position = UDim2.new(0, 0, 0.5, 0)
    RegisterThemeItem("SliderTrackColor", track, "BackgroundColor3")
    track.BackgroundColor3 = DESIGN.SliderTrackColor or Color3.fromRGB(40, 40, 45)
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    
    -- Fill e gradiente, sem alteração de parent
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - minv) / math.max(1, (maxv - minv)), 0, 1, 0)
    fill.BackgroundColor3 = DESIGN.SliderFillColor or Color3.fromRGB(88, 101, 242)
    fill.BorderSizePixel = 0
    fill.ZIndex = 2
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0.9, 0.9, 0.95))
    }
    gradient.Rotation = 90
    gradient.Parent = fill

    -- Thumb
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
    thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 3
    thumb.Parent = sliderFrame
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    -- Anel interno do thumb
    local thumbRing = Instance.new("Frame")
    thumbRing.Size = UDim2.new(0.5, 0, 0.5, 0)
    thumbRing.AnchorPoint = Vector2.new(0.5, 0.5)
    thumbRing.Position = UDim2.new(0.5, 0, 0.5, 0)
    thumbRing.BackgroundColor3 = DESIGN.SliderFillColor or Color3.fromRGB(88, 101, 242)
    thumbRing.BorderSizePixel = 0
    thumbRing.ZIndex = 4
    thumbRing.Parent = thumb
    Instance.new("UICorner", thumbRing).CornerRadius = UDim.new(1, 0)

    -- Badge para o valor
    local valueBadge = Instance.new("Frame")
    valueBadge.Size = UDim2.new(0, 65, 0, 22)
    valueBadge.BackgroundColor3 = DESIGN.SliderFillColor or Color3.fromRGB(88, 101, 242)
    valueBadge.BorderSizePixel = 0
    valueBadge.Parent = trackContainer
    valueBadge.LayoutOrder = 2 -- Segundo elemento
    Instance.new("UICorner", valueBadge).CornerRadius = UDim.new(0, 6)

    -- Detecta se a cor do fundo é clara ou escura
    local function isBright(color)
        local r, g, b = color.R * 255, color.G * 255, color.B * 255
        local brightness = (r * 0.299 + g * 0.587 + b * 0.114)
        return brightness > 160
    end

    -- Define a cor do texto automaticamente
    local autoTextColor = isBright(valueBadge.BackgroundColor3)
        and Color3.fromRGB(20, 20, 20)   -- fundo claro → texto escuro
        or Color3.fromRGB(255, 255, 255) -- fundo escuro → texto branco

    local valueLabel = Instance.new("TextBox")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, 0, 1, 0) -- Ajuste para caber no badge
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextColor3 = autoTextColor
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    valueLabel.Text = tostring(value)
    valueLabel.ClearTextOnFocus = false
    valueLabel.TextEditable = true
    valueLabel.Parent = valueBadge

    -- Lógica
    local connections = {}
    local dragging = false
    local hovering = false

    local publicApi = {
        _instance = nil,
        _connections = nil,
        _onChanged = {},
        _locked = false,
    }
    
    -- Função para reaplicar cores dependentes de SliderFillColor
    function publicApi:_reapplyFillColors()
        valueBadge.BackgroundColor3 = DESIGN.SliderFillColor
        fill.BackgroundColor3 = DESIGN.SliderFillColor
        thumbRing.BackgroundColor3 = DESIGN.SliderFillColor
        
        -- Garante que o estado de Lock seja reaplicado com as novas cores
        publicApi.SetLocked(publicApi._locked)
    end
    
    -- Registra a função para os elementos que usam a cor de preenchimento
    RegisterThemeItem("SliderFillColor", publicApi, "_reapplyFillColors")

    local function updateVisuals(animate)
        -- Agora, a referência de posição é o sliderFrame, não o track
        local trackRef = track -- Usaremos o 'track' para AbsPosition/Size no drag
        
        local denom = math.max(1, (maxv - minv))
        local frac = (value - minv) / denom
        frac = math.clamp(frac, 0, 1)
        
        if animate then
            TweenService:Create(fill, ANIM.FillChange, {
                Size = UDim2.new(frac, 0, 1, 0)
            }):Play()
            TweenService:Create(thumb, ANIM.FillChange, {
                Position = UDim2.new(frac, 0, 0.5, 0)
            }):Play()
        else
            fill.Size = UDim2.new(frac, 0, 1, 0)
            thumb.Position = UDim2.new(frac, 0, 0.5, 0)
        end
        
        local formattedValue = tostring(math.floor((value or 0) * 100) / 100)
        valueLabel.Text = formattedValue
        
        if animate then
            -- Redimensionamento da badge removido, agora o tamanho é fixo (0, 65)
            -- Mas mantemos a animação para dar um feedback visual se necessário
            valueBadge.Size = UDim2.new(0, 70, 0, 22)
            TweenService:Create(valueBadge, ANIM.ValueChange, {
                Size = UDim2.new(0, 65, 0, 22)
            }):Play()
        end
    end

    local function safeCall(fn, ...)
        if type(fn) == "function" then
            pcall(fn, ...)
        end
    end
    
    -- Função de drag aprimorada
    local function handleDrag(inputPos)
        -- A referência de posição absoluta é o 'track'
        local absPos = track.AbsolutePosition or Vector2.new(0, 0)
        local absSize = track.AbsoluteSize or Vector2.new(1, 1)
        local absSizeX = math.max(1, absSize.X)
        local relativeX = math.clamp(inputPos.X - absPos.X, 0, absSizeX)
        local newFrac = relativeX / absSizeX
        newFrac = math.clamp(newFrac, 0, 1)
        local newVal = clamp(roundToStep(minv + newFrac * (maxv - minv)))
        
        if newVal ~= value then
            value = newVal
            updateVisuals(false)
            safeCall(callback, value)
            for _, fn in ipairs(publicApi._onChanged) do
                safeCall(fn, value)
            end
        end
    end
    
    -- Evento para começar o arrasto (InputBegan)
    local function handleInputBegan(input)
        if publicApi._locked then return end
        if input and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            -- Animação de pressão (cores fixas, não temáticas)
            TweenService:Create(thumb, ANIM.ThumbPress, {
                Size = UDim2.new(0, 24, 0, 24)
            }):Play()
            
            pcall(function() handleDrag(input.Position) end)
        end
    end

    local function handleInputChanged(input)
        if dragging and input and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            pcall(function() handleDrag(input.Position) end)
        end
    end

    local function handleInputEnded(input)
        -- Correção mantida: usar Enum.UserInputType.Touch
        if input and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            -- Animação de soltura (cores fixas, não temáticas)
            local targetSize = hovering and UDim2.new(0, 22, 0, 22) or UDim2.new(0, 20, 0, 20)
            TweenService:Create(thumb, ANIM.ThumbHover, {
                Size = targetSize
            }):Play()
        end
    end

    -- Adiciona o InputBegan no 'thumb' e 'track' para iniciar o drag:
    table.insert(connections, track.InputBegan:Connect(handleInputBegan)) -- Clicar/Tocar na barra
    table.insert(connections, thumb.InputBegan:Connect(handleInputBegan)) -- Clicar/Tocar na bolinha (knob)
    
    -- O 'handleInputChanged' e 'handleInputEnded' usam o UserInputService, o que é ideal para o arrasto global.
    table.insert(connections, UIS.InputChanged:Connect(handleInputChanged))
    table.insert(connections, UIS.InputEnded:Connect(handleInputEnded))

    -- Efeito hover no thumb
    table.insert(connections, thumb.MouseEnter:Connect(function()
        if publicApi._locked then return end
        hovering = true
        if not dragging then
            TweenService:Create(thumb, ANIM.ThumbHover, {
                Size = UDim2.new(0, 22, 0, 22)
            }):Play()
        end
    end))

    table.insert(connections, thumb.MouseLeave:Connect(function()
        hovering = false
        if not dragging then
            TweenService:Create(thumb, ANIM.ThumbHover, {
                Size = UDim2.new(0, 20, 0, 20)
            }):Play()
        end
    end))
    
    -- Input filter for numbers only
    table.insert(connections, valueLabel:GetPropertyChangedSignal("Text"):Connect(function()
        local text = valueLabel.Text
        local filtered = text:gsub("[^%d%.%-]", "")
        if filtered ~= text then
            valueLabel.Text = filtered
        end
    end))

    -- Update on focus lost
    table.insert(connections, valueLabel.FocusLost:Connect(function()
        if publicApi._locked then
            valueLabel.Text = tostring(math.floor((value or 0) * 100) / 100)
            return
        end
        local newVal = tonumber(valueLabel.Text)
        if newVal then
            newVal = clamp(roundToStep(newVal))
            value = newVal
            updateVisuals(true)
            safeCall(callback, value)
            for _, fn in ipairs(publicApi._onChanged) do
                safeCall(fn, value)
            end
        else
            valueLabel.Text = tostring(math.floor((value or 0) * 100) / 100)
        end
    end))

    publicApi._instance = box
    publicApi._connections = connections

    -- API pública
    function publicApi.Set(v)
        value = clamp(roundToStep(tonumber(v) or value))
        updateVisuals(true)
        safeCall(callback, value)
        for _, fn in ipairs(publicApi._onChanged) do
            safeCall(fn, value)
        end
    end

    function publicApi.Get()
        return value
    end

    function publicApi.GetPercent()
        if maxv == minv then return 0 end
        return (value - minv) / (maxv - minv)
    end

    function publicApi.SetRange(min, max, s)
        minv = tonumber(min) or minv
        maxv = tonumber(max) or maxv
        if s ~= nil then step = tonumber(s) or step end
        value = clamp(roundToStep(value))
        updateVisuals(true)
    end

    function publicApi.AnimateTo(targetValue, duration)
        local newVal = clamp(roundToStep(tonumber(targetValue) or value))
        local denom = math.max(1, (maxv - minv))
        local frac = (newVal - minv) / denom
        local dur = tonumber(duration) or 0.3
        
        pcall(function()
            TweenService:Create(fill, TweenInfo.new(dur, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Size = UDim2.new(frac, 0, 1, 0)
            }):Play()
            TweenService:Create(thumb, TweenInfo.new(dur, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Position = UDim2.new(frac, 0, 0.5, 0)
            }):Play()
        end)
        
        value = newVal
        valueLabel.Text = tostring(math.floor(value * 100) / 100)
        safeCall(callback, value)
        for _, fn in ipairs(publicApi._onChanged) do
            safeCall(fn, value)
        end
    end

    function publicApi.OnChanged(fn)
        if type(fn) == "function" then
            table.insert(publicApi._onChanged, fn)
        end
    end

    function publicApi.SetLocked(state)
        publicApi._locked = state and true or false
        valueLabel.TextEditable = not publicApi._locked
        
        -- Aplica transparência baseada no estado de lock
        local fillColor = publicApi._locked and DESIGN.SliderFillColor:lerp(Color3.new(0, 0, 0), 0.5) or DESIGN.SliderFillColor
        
        TweenService:Create(thumb, ANIM.ThumbHover, {
            BackgroundTransparency = publicApi._locked and 0.5 or 0
        }):Play()
        TweenService:Create(thumbRing, ANIM.ThumbHover, {
            BackgroundColor3 = fillColor,
            BackgroundTransparency = publicApi._locked and 0.7 or 0
        }):Play()
        TweenService:Create(fill, ANIM.ThumbHover, {
            BackgroundColor3 = fillColor,
            BackgroundTransparency = publicApi._locked and 0.6 or 0
        }):Play()
        TweenService:Create(track, ANIM.ThumbHover, {
            BackgroundTransparency = publicApi._locked and 0.7 or 0
        }):Play()
        TweenService:Create(valueBadge, ANIM.ThumbHover, {
            BackgroundColor3 = fillColor,
            BackgroundTransparency = publicApi._locked and 0.6 or 0
        }):Play()
        TweenService:Create(valueLabel, ANIM.ThumbHover, {
            TextTransparency = publicApi._locked and 0.5 or 0
        }):Play()
    end

    function publicApi.Update(newOptions)
        options = newOptions or options
        title = options.Text or title
        minv = tonumber(options.Min) or minv
        maxv = tonumber(options.Max) or maxv
        step = tonumber(options.Step) or step
        value = tonumber(options.Value) or value
        callback = options.Callback or callback
        value = clamp(roundToStep(value))
        titleLabel.Text = title
        updateVisuals(true)
    end

    function publicApi.Destroy()
        dragging = false
        hovering = false
        for _, c in ipairs(connections) do
            if c then
                pcall(function() c:Disconnect() end)
            end
        end
        if publicApi._instance and publicApi._instance.Parent then
            pcall(function() publicApi._instance:Destroy() end)
        end
        publicApi._instance = nil
        publicApi._connections = nil
        publicApi._onChanged = nil
    end

    updateVisuals(false)
    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateTextBox(tab, options)
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateTextBox")
    assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateTextBox")

    local title = options.Text or "Log"
    local desc = options.Desc
    local defaultText = options.Default or ""
    local readonly = options.ReadOnly or true

    -- // CONTAINER BASE
    local boxHolder = Instance.new("Frame")
    boxHolder.Name = "TextBox"
    RegisterThemeItem("ComponentBackground", boxHolder, "BackgroundColor3")
    boxHolder.BackgroundColor3 = DESIGN.ComponentBackground
    boxHolder.Size = UDim2.new(1, 0, 0, desc and 140 or 120)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    corner.Parent = boxHolder

    local stroke = Instance.new("UIStroke")
    RegisterThemeItem("HRColor", stroke, "Color")
    stroke.Color = DESIGN.HRColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = boxHolder

    -- // LAYOUT BASE
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingBottom = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)
    padding.Parent = boxHolder

    -- // TÍTULO
    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.Gotham
    RegisterThemeItem("ComponentTextColor", titleLabel, "TextColor3")
    titleLabel.TextColor3 = DESIGN.ComponentTextColor
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Size = UDim2.new(1, -10, 0, 18)
    titleLabel.Parent = boxHolder

    -- // SUBTÍTULO
    local currentY = 22
    if desc then
        local sub = Instance.new("TextLabel")
        sub.BackgroundTransparency = 1
        sub.Text = desc
        sub.Font = Enum.Font.GothamSemibold
        -- A cor do subtítulo (150, 150, 150) é fixada, mas pode ser registrada em uma chave de texto secundária se existir.
        -- Vou manter como fixada aqui, ou usar EmptyStateTextColor se for semanticamente correto.
        sub.TextColor3 = Color3.fromRGB(150, 150, 150)
        sub.TextSize = 12
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Position = UDim2.new(0, 0, 0, currentY)
        sub.Size = UDim2.new(1, -10, 0, 16)
        sub.Parent = boxHolder
        currentY += 20
    end

    -- // CONTAINER DO TEXTO (com scroll)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    -- BackgroundColor3 e ScrollBarImageColor3 serão definidas/atualizadas em updateInteractivity
    scroll.BackgroundColor3 = DESIGN.InputBackgroundColor 
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.new(0, 0, 0, currentY + 6)
    scroll.Size = UDim2.new(1, 0, 1, desc and -currentY - 14 or -28)
    scroll.ScrollBarThickness = 4
    RegisterThemeItem("SliderTrackColor", scroll, "ScrollBarImageColor3")
    scroll.ScrollBarImageColor3 = DESIGN.SliderTrackColor
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ClipsDescendants = true
    scroll.Active = true
    scroll.Parent = boxHolder

    local innerPadding = Instance.new("UIPadding")
    innerPadding.PaddingTop = UDim.new(0, 6)
    innerPadding.PaddingLeft = UDim.new(0, 6)
    innerPadding.PaddingRight = UDim.new(0, 6)
    innerPadding.PaddingBottom = UDim.new(0, 6)
    innerPadding.Parent = scroll

    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 6)
    scrollCorner.Parent = scroll

    local scrollStroke = Instance.new("UIStroke")
    scrollStroke.Color = DESIGN.SliderTrackColor
    scrollStroke.Thickness = 1
    scrollStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    scrollStroke.Parent = scroll

    -- // TEXTO PRINCIPAL
    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    RegisterThemeItem("InputTextColor", textLabel, "TextColor3")
    textLabel.TextColor3 = DESIGN.InputTextColor
    textLabel.Font = Enum.Font.Code
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.Text = defaultText
    textLabel.Size = UDim2.new(1, -8, 0, 0)
    textLabel.AutomaticSize = Enum.AutomaticSize.Y
    textLabel.Parent = scroll

    -- // INTERAÇÃO
    local function updateInteractivity()
        local blocked = self.Blocked or readonly
        scroll.Active = not blocked
        -- TextTransparency: não precisa de registro de tema
        textLabel.TextTransparency = blocked and 0.5 or 0
        
        -- BackgroundColor3 do Scroll
        local scrollBgColor = blocked and DESIGN.WindowColor2 or DESIGN.InputBackgroundColor
        scroll.BackgroundColor3 = scrollBgColor
        
        -- StrokeColor do Scroll
        local scrollStrokeColor = blocked and DESIGN.HRColor or DESIGN.SliderTrackColor
        scrollStroke.Color = scrollStrokeColor
    end

    updateInteractivity()

    -- // API PÚBLICA
    local publicApi = {
        _instance = boxHolder,
        _scroll = scroll,
        _label = textLabel,
        _readonly = readonly
    }

    -- Função para forçar a reaplicação de cores dinâmicas
    function publicApi:_reapplyThemeColors()
        updateInteractivity()
    end

    -- Registra para que a cor de fundo/contorno do scroll seja restaurada quando o tema muda
    RegisterThemeItem("InputBackgroundColor", publicApi, "_reapplyThemeColors")
    RegisterThemeItem("WindowColor2", publicApi, "_reapplyThemeColors")
    RegisterThemeItem("SliderTrackColor", publicApi, "_reapplyThemeColors")
    RegisterThemeItem("HRColor", publicApi, "_reapplyThemeColors")


    function publicApi:SetText(newText)
        textLabel.Text = tostring(newText)
        task.wait()
        scroll.CanvasPosition = Vector2.new(0, math.huge)
    end

    function publicApi:GetText()
        return textLabel.Text
    end

    function publicApi:Append(line)
        textLabel.Text = textLabel.Text .. "\n" .. tostring(line)
        task.wait()
        scroll.CanvasPosition = Vector2.new(0, math.huge)
    end

    function publicApi:Clear()
        textLabel.Text = ""
    end

    function publicApi:SetBlocked(state)
        self._blocked = state
        updateInteractivity()
    end

    function publicApi:Destroy()
        if publicApi._instance then
            publicApi._instance:Destroy()
            publicApi._instance = nil
        end
    end

    table.insert(tab.Components, publicApi)
    boxHolder.Parent = tab.Container

    if self.BlockChanged then
        self.BlockChanged:Connect(updateInteractivity)
    end

    return publicApi
end


function Tekscripts:CreateBind(tab, options)
	assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateBind")
	assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateBind")

	local title = options.Text or "Keybind"
	local desc = options.Desc
	local defaultKey = options.Default or Enum.KeyCode.F
	local callback = typeof(options.Callback) == "function" and options.Callback or function() end

	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService") -- Necessário para a animação de erro

	-- CRIAÇÃO DE ELEMENTOS
	local box = Instance.new("Frame")
	box.Name = "BindBox"
	RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
	box.BackgroundColor3 = DESIGN.ComponentBackground
    box.BackgroundTransparency = DESIGN.TabContainerTransparency
	box.Size = UDim2.new(1, 0, 0, desc and DESIGN.ComponentHeight + 10 or DESIGN.ComponentHeight)
	box.ClipsDescendants = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
	corner.Parent = box

	local stroke = Instance.new("UIStroke")
	RegisterThemeItem("HRColor", stroke, "Color")
	stroke.Color = DESIGN.HRColor
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = box

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, DESIGN.ComponentPadding / 2)
	padding.PaddingBottom = UDim.new(0, DESIGN.ComponentPadding / 2)
	padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
	padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)
	padding.Parent = box

	local holder = Instance.new("Frame")
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.new(1, 0, 1, 0)
	holder.Parent = box

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Text = title
	label.Font = Enum.Font.Gotham
	RegisterThemeItem("ComponentTextColor", label, "TextColor3")
	label.TextColor3 = DESIGN.ComponentTextColor
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(1, -80, 1, 0)
	label.Parent = holder

	if desc then
		label.TextYAlignment = Enum.TextYAlignment.Top
		local sub = Instance.new("TextLabel")
		sub.BackgroundTransparency = 1
		sub.Text = desc
		sub.Font = Enum.Font.GothamSemibold
		RegisterThemeItem("EmptyStateTextColor", sub, "TextColor3")
		sub.TextColor3 = DESIGN.EmptyStateTextColor
		sub.TextSize = 12
		sub.TextXAlignment = Enum.TextXAlignment.Left
		sub.TextYAlignment = Enum.TextYAlignment.Bottom
		sub.Size = UDim2.new(1, -80, 1, 0)
		sub.Parent = holder
	end

	local button = Instance.new("TextButton")
	button.AnchorPoint = Vector2.new(1, 0.5)
	button.Position = UDim2.new(1, -DESIGN.ComponentPadding, 0.5, 0)
	button.Size = UDim2.new(0, 80, 0, DESIGN.ComponentHeight * 0.5)
	RegisterThemeItem("InputBackgroundColor", button, "BackgroundColor3")
	button.BackgroundColor3 = DESIGN.InputBackgroundColor
	RegisterThemeItem("InputTextColor", button, "TextColor3")
	button.TextColor3 = DESIGN.InputTextColor
	button.Text = defaultKey.Name
	button.Font = Enum.Font.Gotham
	button.TextSize = 13
	button.AutoButtonColor = false
	button.Parent = holder

	local btnStroke = Instance.new("UIStroke")
	RegisterThemeItem("HRColor", btnStroke, "Color")
	btnStroke.Color = DESIGN.HRColor
	btnStroke.Thickness = 1
	btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	btnStroke.Parent = button

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, DESIGN.CornerRadius / 2)
	btnCorner.Parent = button

	-- SEGURANÇA DE ESTADO
	local destroyed = false
	local listening = false
	local currentKey = defaultKey
	local connections = {}

	-- FUNÇÃO SEGURA DE CONEXÃO
	local function safeConnect(signal, func)
		local conn = signal:Connect(function(...)
			if destroyed then return end
			local ok, err = pcall(func, ...)
			if not ok then
				warn("[CreateBind:CallbackError]:", err)
			end
		end)
		table.insert(connections, conn)
		return conn
	end

	-- LISTEN SEGURO
	local function listenForKey()
		if listening or destroyed then return end
		listening = true
		button.Text = "Pressione..."
		
		-- Tween para cor de listening
		local oldColor = button.BackgroundColor3
		TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 170, 0) }):Play()

		local inputConn
		inputConn = safeConnect(UserInputService.InputBegan, function(input, processed)
			if destroyed or processed or not listening then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				currentKey = input.KeyCode
				pcall(function()
					if button then 
						button.Text = currentKey.Name 
						TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = DESIGN.InputBackgroundColor }):Play()
					end
				end)
				listening = false
				if inputConn and inputConn.Connected then
					inputConn:Disconnect()
				end
			end
		end)
	end

	-- FEEDBACK SEGURO
	safeConnect(button.MouseEnter, function()
		if button and not destroyed and not listening then
			-- Lê DESIGN.ItemHoverColor
			button.BackgroundColor3 = DESIGN.ItemHoverColor
		end
	end)

	safeConnect(button.MouseLeave, function()
		if button and not destroyed and not listening then
			-- Retorna para DESIGN.InputBackgroundColor
			button.BackgroundColor3 = DESIGN.InputBackgroundColor
		end
	end)

	safeConnect(button.MouseButton1Click, function()
		listenForKey()
	end)

	safeConnect(UserInputService.InputBegan, function(input, processed)
		if destroyed or processed then return end
		if input.KeyCode == currentKey and not self.Blocked then
			local ok, err = pcall(callback, currentKey)
			if not ok then
				warn("[BindError]:", err)
				pcall(function()
					if button and not destroyed then
						-- Animação de erro
						TweenService:Create(button, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(200, 80, 80) }):Play()
						task.delay(0.25, function()
							if button and not destroyed then
								-- Retorna para a cor normal (DESIGN.InputBackgroundColor)
								TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = DESIGN.InputBackgroundColor }):Play()
							end
						end)
					end
				end)
			end
		end
	end)

	-- API PÚBLICA SEGURA
	local publicApi = {
		_instance = box,
		_connections = connections,
	}

	-- Função para forçar a cor normal após troca de tema
	function publicApi:_reapplyButtonColor()
		if button and not destroyed and not listening then
			button.BackgroundColor3 = DESIGN.InputBackgroundColor
		end
	end
	-- Registra para que a cor normal seja restaurada quando o tema muda
	RegisterThemeItem("InputBackgroundColor", publicApi, "_reapplyButtonColor")
	RegisterThemeItem("ItemHoverColor", publicApi, "_reapplyButtonColor")

	function publicApi:GetKey()
		return currentKey
	end

	function publicApi:SetKey(newKey)
		if destroyed then return end
		if typeof(newKey) == "EnumItem" and newKey.EnumType == Enum.KeyCode then
			currentKey = newKey
			pcall(function()
				if button then button.Text = newKey.Name end
			end)
		end
	end

	function publicApi:Listen()
		if not destroyed then
			listenForKey()
		end
	end

	function publicApi:Update(newOptions)
		if destroyed or not newOptions then return end
		pcall(function()
			if newOptions.Text then label.Text = newOptions.Text end
			if newOptions.Desc then desc = newOptions.Desc end
			if newOptions.Default then
				currentKey = newOptions.Default
				button.Text = newOptions.Default.Name
			end
		end)
	end

	function publicApi:Destroy()
		if destroyed then return end
		destroyed = true
		pcall(function()
			for _, conn in ipairs(connections) do
				if conn and conn.Connected then conn:Disconnect() end
			end
			table.clear(connections)
			if box then box:Destroy() end
		end)
	end

	table.insert(tab.Components, publicApi)
	box.Parent = tab.Container

	return publicApi
end

function Tekscripts:CreateDropdown(tab: any, options: {
    Title: string,
    Values: { { Name: string, Image: string? } },
    Callback: (selected: {string} | string) -> (),
    MultiSelect: boolean?,
    MaxVisibleItems: number?,
    InitialValues: {string}?
})
    assert(type(tab) == "table" and tab.Container, "Objeto 'tab' inválido")
    assert(type(options) == "table" and type(options.Title) == "string" and type(options.Values) == "table", "Argumentos inválidos")

    local TweenService = game:GetService("TweenService")

    local multiSelect = options.MultiSelect or false
    local maxVisibleItems = math.min(options.MaxVisibleItems or 5, 8)
    local itemHeight = 44
    local imagePadding = 8
    local imageSize = itemHeight - (imagePadding * 2)
    
    local box = Instance.new("Frame")
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.Size = UDim2.new(1, 0, 0, 0)
    -- REGISTRO DE TEMA PADRÃO
    RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
    box.BackgroundColor3 = DESIGN.ComponentBackground
    box.BackgroundTransparency = DESIGN.TabContainerTransparency
    box.BorderSizePixel = 0
    box.Parent = tab.Container
    addRoundedCorners(box, DESIGN.CornerRadius)

    local boxLayout = Instance.new("UIListLayout")
    boxLayout.Padding = UDim.new(0, 0)
    boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
    boxLayout.Parent = box
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(1, 0, 0, 50)
    main.BackgroundTransparency = 1
    main.LayoutOrder = 1
    main.Parent = box

    local mainPadding = Instance.new("UIPadding")
    mainPadding.PaddingLeft = UDim.new(0, 12)
    mainPadding.PaddingRight = UDim.new(0, 12)
    mainPadding.PaddingTop = UDim.new(0, 12)
    mainPadding.PaddingBottom = UDim.new(0, 12)
    mainPadding.Parent = main

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = options.Title
    title.Size = UDim2.new(1, -110, 1, 0)
    title.BackgroundTransparency = 1
    -- REGISTRO DE TEMA PADRÃO
    RegisterThemeItem("ComponentTextColor", title, "TextColor3")
    title.TextColor3 = DESIGN.ComponentTextColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Parent = main

    local botaoText = createButton("Selecionar ▼", UDim2.new(0, 100, 1, 0), main)
    botaoText.Name = "BotaoText"
    botaoText.Position = UDim2.new(1, -100, 0, 0)
    botaoText.TextSize = 13
    -- **ASSUMINDO** que 'createButton' já faz o registro para cores de texto e fundo/hover do botão.
    botaoText.Parent = main

    local lister = Instance.new("ScrollingFrame")
    lister.Name = "Lister"
    lister.Size = UDim2.new(1, 0, 0, 0)
    lister.BackgroundTransparency = 1
    lister.BorderSizePixel = 0
    lister.ClipsDescendants = true
    -- REGISTRO DE TEMA PADRÃO (Barra de rolagem)
    RegisterThemeItem("AccentColor", lister, "ScrollBarImageColor3")
    lister.ScrollBarImageColor3 = DESIGN.AccentColor
    lister.ScrollBarThickness = 5
    lister.ScrollingDirection = Enum.ScrollingDirection.Y
    lister.CanvasSize = UDim2.new(0, 0, 0, 0)
    lister.AutomaticCanvasSize = Enum.AutomaticSize.Y
    lister.LayoutOrder = 2
    lister.Parent = box

    local listerLayout = Instance.new("UIListLayout")
    listerLayout.Padding = UDim.new(0, 4)
    listerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listerLayout.Parent = lister

    local listerPadding = Instance.new("UIPadding")
    listerPadding.PaddingLeft = UDim.new(0, 12)
    listerPadding.PaddingRight = UDim.new(0, 12)
    listerPadding.PaddingTop = UDim.new(0, 8)
    listerPadding.PaddingBottom = UDim.new(0, 12)
    listerPadding.Parent = lister

    local isOpen = false
    local selectedValues = {}
    local connections = {}
    local itemElements = {}
    local itemOrder = {}

    local function formatSelectedValues(values)
        if multiSelect then
            if #values == 0 then return "Nenhum item selecionado" end
            return table.concat(values, ", ")
        else
            return values or "Nenhum item selecionado"
        end
    end

    local function updateButtonText()
        local arrow = isOpen and "▲" or "▼"
        if #selectedValues == 0 then
            botaoText.Text = "Selecionar " .. arrow
        elseif #selectedValues == 1 then
            local displayText = selectedValues[1]
            if #displayText > 10 then displayText = string.sub(displayText, 1, 10) .. "..." end
            botaoText.Text = displayText .. " " .. arrow
        else
            botaoText.Text = string.format("%d itens %s", #selectedValues, arrow)
        end
    end

    local function toggleDropdown()
        isOpen = not isOpen
        local numItems = #itemOrder
        local totalItemHeight = (numItems * itemHeight) + ((numItems - 1) * listerLayout.Padding.Offset)
        local maxHeight = (maxVisibleItems * itemHeight) + ((maxVisibleItems - 1) * listerLayout.Padding.Offset)
        local targetHeight = isOpen and math.min(totalItemHeight + listerPadding.PaddingTop.Offset + listerPadding.PaddingBottom.Offset, maxHeight + listerPadding.PaddingTop.Offset + listerPadding.PaddingBottom.Offset) or 0
        
        -- Atualiza CanvasSize antes de fazer a transição de tamanho do lister para garantir a barra de rolagem correta
        lister.CanvasSize = UDim2.new(0, 0, 0, listerLayout.AbsoluteContentSize.Y)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        TweenService:Create(lister, tweenInfo, { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
        updateButtonText()
    end

    local function setItemSelected(valueName, isSelected)
        local elements = itemElements[valueName]
        if not elements then return end
        
        local targetColor = isSelected and DESIGN.AccentColor or DESIGN.ComponentBackground
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
        TweenService:Create(elements.container, tweenInfo, { BackgroundColor3 = targetColor }):Play()
        
        -- Garante que o indicador use a cor atualizada do tema AccentColor
        if elements.indicator then
            elements.indicator.Visible = isSelected
            if isSelected then
                elements.indicator.BackgroundColor3 = DESIGN.AccentColor
            end
        end
        
        -- **[MUDANÇA APLICADA]**
        if multiSelect and elements.checkIconImage then
             -- A imagem de check deve ser visível (true) quando o item está selecionado
            elements.checkIconImage.Visible = isSelected
        end
    end

    local function toggleItemSelection(valueName)
        local isCurrentlySelected = table.find(selectedValues, valueName)
        
        if multiSelect then
            if isCurrentlySelected then
                table.remove(selectedValues, isCurrentlySelected)
                setItemSelected(valueName, false)
            else
                table.insert(selectedValues, valueName)
                setItemSelected(valueName, true)
            end
        else
            -- Deseleciona todos os itens para o modo single select
            for name, _ in pairs(itemElements) do setItemSelected(name, false) end
            if isCurrentlySelected then
                selectedValues = {}
            else
                selectedValues = { valueName }
                setItemSelected(valueName, true)
            end
            -- Adicionado um pequeno atraso para a animação do tween ter tempo de começar antes de fechar.
            if isOpen and not isCurrentlySelected then task.delay(0.15, toggleDropdown) end
        end
        
        updateButtonText()
        local selected = multiSelect and selectedValues or (selectedValues[1] or nil)
        if options.Callback then options.Callback(selected) end
    end

    local function createItem(valueInfo, index)
        local hasImage = valueInfo.Image and valueInfo.Image ~= ""
        
        local itemContainer = Instance.new("TextButton")
        itemContainer.Name = "Item_" .. index
        itemContainer.Size = UDim2.new(1, 0, 0, itemHeight)
        -- REGISTRO DE TEMA PADRÃO
        RegisterThemeItem("ComponentBackground", itemContainer, "BackgroundColor3")
        itemContainer.BackgroundColor3 = DESIGN.ComponentBackground
        itemContainer.BackgroundTransparency = DESIGN.TabContainerTransparency 
        itemContainer.BorderSizePixel = 0
        itemContainer.Text = ""
        itemContainer.AutoButtonColor = false
        itemContainer.LayoutOrder = index
        itemContainer.Parent = lister
        addRoundedCorners(itemContainer, DESIGN.CornerRadius - 2)

        local itemPadding = Instance.new("UIPadding")
        itemPadding.PaddingLeft = UDim.new(0, 10)
        itemPadding.PaddingRight = UDim.new(0, 10)
        itemPadding.Parent = itemContainer

        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = itemContainer

        local indicator
        local checkIconImage -- Variável para a nova imagem de check

        if multiSelect then
            indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 18, 0, 18)
            indicator.Position = UDim2.new(1, -18, 0.5, -9)
            -- REGISTRO DE TEMA PADRÃO
            RegisterThemeItem("AccentColor", indicator, "BackgroundColor3")
            indicator.BackgroundColor3 = DESIGN.AccentColor
            indicator.BorderSizePixel = 0
            indicator.Visible = false
            indicator.Parent = contentFrame
            addRoundedCorners(indicator, UDim.new(0, 3))
            
            -- **[MUDANÇA APLICADA]** Substitui TextLabel por ImageLabel
            checkIconImage = Instance.new("ImageLabel")
            checkIconImage.Size = UDim2.new(1, 0, 1, 0)
            checkIconImage.BackgroundTransparency = 1
            checkIconImage.Image = "rbxassetid://10709790644" -- O ID da imagem fornecido
            checkIconImage.ImageColor3 = Color3.fromRGB(255, 255, 255) -- Cor branca para garantir contraste
            checkIconImage.ScaleType = Enum.ScaleType.Fit
            checkIconImage.Visible = false -- Inicia invisível
            checkIconImage.Parent = indicator
        else
            indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 8, 0, 8)
            indicator.Position = UDim2.new(1, -8, 0.5, -4)
            -- REGISTRO DE TEMA PADRÃO
            RegisterThemeItem("AccentColor", indicator, "BackgroundColor3")
            indicator.BackgroundColor3 = DESIGN.AccentColor
            indicator.BorderSizePixel = 0
            indicator.Visible = false
            indicator.Parent = contentFrame
            addRoundedCorners(indicator, UDim.new(1, 0))
        end

        local foto
        if hasImage then
            foto = Instance.new("ImageLabel")
            foto.Name = "Foto"
            foto.Size = UDim2.new(0, imageSize, 0, imageSize)
            foto.Position = UDim2.new(0, 0, 0.5, -imageSize/2)
            foto.BackgroundTransparency = 1
            foto.Image = valueInfo.Image
            foto.ScaleType = Enum.ScaleType.Fit
            foto.Parent = contentFrame
            addRoundedCorners(foto, UDim.new(0, 4))
        end

        local textXOffset = hasImage and (imageSize + 8) or 0
        local textWidth = multiSelect and -30 or -12
        
        local itemText = Instance.new("TextLabel")
        itemText.Name = "ConteudoText"
        itemText.Size = UDim2.new(1, textWidth, 1, 0)
        itemText.Position = UDim2.new(0, textXOffset, 0, 0)
        itemText.BackgroundTransparency = 1
        itemText.Text = valueInfo.Name
        -- REGISTRO DE TEMA PADRÃO
        RegisterThemeItem("ComponentTextColor", itemText, "TextColor3")
        itemText.TextColor3 = DESIGN.ComponentTextColor
        itemText.Font = Enum.Font.Gotham
        itemText.TextSize = 14
        itemText.TextXAlignment = Enum.TextXAlignment.Left
        itemText.TextYAlignment = Enum.TextYAlignment.Center
        itemText.TextTruncate = Enum.TextTruncate.AtEnd
        itemText.Parent = contentFrame
        
        -- **[MUDANÇA CRUCIAL]** Função que aplica a cor do tema SEM animação (TweenService)
        local function forceItemColorUpdate(selectedState)
            local targetColor = selectedState and DESIGN.AccentColor or DESIGN.ComponentBackground
            itemContainer.BackgroundColor3 = targetColor
            if indicator then 
                indicator.Visible = selectedState 
                -- Garante que o indicador (AccentColor) se atualize imediatamente também
                if multiSelect and selectedState then indicator.BackgroundColor3 = DESIGN.AccentColor end 
            end
            -- **[MUDANÇA APLICADA]**
            if multiSelect and checkIconImage then
                checkIconImage.Visible = selectedState
            end
        end

        itemElements[valueInfo.Name] = {
            container = itemContainer,
            indicator = indicator,
            text = itemText,
            foto = foto,
            checkIconImage = checkIconImage, -- **[MUDANÇA APLICADA]** Adiciona a referência ao ImageLabel
            forceColorUpdate = forceItemColorUpdate, -- **[MUDANÇA CRUCIAL]** Adiciona a função para ser chamada na mudança de tema
            connections = {}
        }

        itemElements[valueInfo.Name].connections.MouseClick = itemContainer.MouseButton1Click:Connect(function()
            toggleItemSelection(valueInfo.Name)
        end)

        itemElements[valueInfo.Name].connections.MouseEnter = itemContainer.MouseEnter:Connect(function()
            if not table.find(selectedValues, valueInfo.Name) then
                -- Usa o ItemHoverColor, registrado para o tema
                local hoverColor = DESIGN.ItemHoverColor or Color3.fromRGB(45, 45, 50) 
                TweenService:Create(itemContainer, TweenInfo.new(0.15), { BackgroundColor3 = hoverColor }):Play()
            end
        end)

        itemElements[valueInfo.Name].connections.MouseLeave = itemContainer.MouseLeave:Connect(function()
            if not table.find(selectedValues, valueInfo.Name) then
                -- Volta para ComponentBackground, registrado para o tema
                TweenService:Create(itemContainer, TweenInfo.new(0.15), { BackgroundColor3 = DESIGN.ComponentBackground }):Play()
            end
        end)
    end

    for index, valueInfo in ipairs(options.Values) do
        table.insert(itemOrder, valueInfo.Name)
        createItem(valueInfo, index)
    end

    if options.InitialValues then
        for _, valueToSelect in ipairs(options.InitialValues) do
            if itemElements[valueToSelect] then
                table.insert(selectedValues, valueToSelect)
                -- **[MUDANÇA APLICADA]** Agora usa a função forceItemColorUpdate para aplicar a cor inicial SEM tween (evitando o flash do ComponentBackground)
                itemElements[valueToSelect].forceColorUpdate(true)
            end
        end
        updateButtonText()
    end

    connections.ButtonClick = botaoText.MouseButton1Click:Connect(toggleDropdown)

    local publicApi = {
        _instance = box,
        _connections = connections,
        _itemElements = itemElements,
    }
    
    -- **[MUDANÇA CRUCIAL]** Função de re-aplicação de cores para o tema (sem animação para ser imediato)
    function publicApi:_reapplyItemColors()
        for name, elements in pairs(publicApi._itemElements) do
            local isSelected = table.find(selectedValues, name)
            -- Chama a função que define a cor **sem** tweening
            elements.forceColorUpdate(isSelected) 
        end
    end

    -- **[MUDANÇA CRUCIAL]** Registra a publicApi para que a função de re-aplicação seja chamada quando as cores AccentColor e ComponentBackground mudarem
    RegisterThemeItem("AccentColor", publicApi, "_reapplyItemColors")
    RegisterThemeItem("ComponentBackground", publicApi, "_reapplyItemColors")
    -- ItemHoverColor só afeta MouseEnter, mas pode ser registrado para consistência, embora o mais importante seja Accent e ComponentBackground
    RegisterThemeItem("ItemHoverColor", publicApi, "_reapplyItemColors")

    function publicApi:AddItem(valueInfo, position)
        assert(type(valueInfo) == "table" and type(valueInfo.Name) == "string", "valueInfo inválido")
        assert(not itemElements[valueInfo.Name], "Item já existe")
        
        position = position or (#itemOrder + 1)
        position = math.clamp(position, 1, #itemOrder + 1)
        
        table.insert(itemOrder, position, valueInfo.Name)
        createItem(valueInfo, position)
        
        for i, name in ipairs(itemOrder) do
            if itemElements[name] then itemElements[name].container.LayoutOrder = i end
        end
        
        -- Alterna para reativar o dropdown com o novo tamanho (fluente)
        if isOpen then toggleDropdown() task.delay(0.3, toggleDropdown) end
    end

    function publicApi:RemoveItem(valueName)
        assert(type(valueName) == "string", "valueName deve ser string")
        if itemElements[valueName] then
            local elements = itemElements[valueName]
            -- Desconecta e remove registros de tema do item
            for _, conn in pairs(elements.connections) do
                if conn and conn.Connected then conn:Disconnect() end
            end
            RegisterThemeItem("ComponentBackground", elements.container, "BackgroundColor3", true)
            RegisterThemeItem("ComponentTextColor", elements.text, "TextColor3", true)
            if elements.indicator then RegisterThemeItem("AccentColor", elements.indicator, "BackgroundColor3", true) end

            elements.container:Destroy()
            itemElements[valueName] = nil
            
            local idx = table.find(itemOrder, valueName)
            if idx then table.remove(itemOrder, idx) end
            
            idx = table.find(selectedValues, valueName)
            if idx then table.remove(selectedValues, idx) end
            
            updateButtonText()
            local selected = multiSelect and selectedValues or (selectedValues[1] or nil)
            if options.Callback then options.Callback(selected) end
            
            -- Alterna para reativar o dropdown com o novo tamanho (fluente)
            if isOpen then toggleDropdown() task.delay(0.3, toggleDropdown) end
        end
    end

    function publicApi:ClearItems()
        -- Usa 'self' para chamar a função RemoveItem, garantindo a desassociação do tema
        while #itemOrder > 0 do self:RemoveItem(itemOrder[1]) end
    end

    function publicApi:Destroy()
        if self._instance then
            -- Remove a publicApi dos registros de tema
            RegisterThemeItem("AccentColor", self, "_reapplyItemColors", true)
            RegisterThemeItem("ComponentBackground", self, "_reapplyItemColors", true)
            RegisterThemeItem("ItemHoverColor", self, "_reapplyItemColors", true)

            for _, conn in pairs(self._connections) do
                if conn and conn.Connected then conn:Disconnect() end
            end
            
            -- Remove registros de tema e desconecta conexões dos elementos do item
            for name, _ in pairs(itemElements) do
                self:RemoveItem(name) -- Reutiliza RemoveItem para limpar tudo corretamente
            end

            -- Remove registros de tema dos elementos principais (box, title, lister)
            RegisterThemeItem("ComponentBackground", box, "BackgroundColor3", true)
            RegisterThemeItem("ComponentTextColor", title, "TextColor3", true)
            RegisterThemeItem("AccentColor", lister, "ScrollBarImageColor3", true)

            self._instance:Destroy()
            self._instance = nil
            itemElements = {}
            itemOrder = {}
            selectedValues = {}
        end
    end

    function publicApi:GetSelected()
        return multiSelect and selectedValues or (selectedValues[1] or nil)
    end

    function publicApi:GetSelectedFormatted()
        return formatSelectedValues(multiSelect and selectedValues or (selectedValues[1] or nil))
    end

    function publicApi:SetSelected(values)
        -- Deseleciona todos os itens **com** tween (para dar um feedback visual)
        for name, _ in pairs(itemElements) do setItemSelected(name, false) end
        selectedValues = {}
        
        local valuesToSet = type(values) == "table" and values or {values}
        for _, value in ipairs(valuesToSet) do
            if itemElements[value] then
                table.insert(selectedValues, value)
                -- Seleciona os novos itens **com** tween
                setItemSelected(value, true)
            end
        end
        
        updateButtonText()
        local selected = multiSelect and selectedValues or (selectedValues[1] or nil)
        if options.Callback then options.Callback(selected) end
    end

    function publicApi:Toggle()
        toggleDropdown()
    end

    function publicApi:Close()
        if isOpen then toggleDropdown() end
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end


function Tekscripts:CreateDialog(options) 
    assert(type(options) == "table", "Invalid options")

    local titleText = options.Title or "Título"
    local messageText = options.Message or "Mensagem"
    local buttons = options.Buttons or { {Text = "Ok", Callback = function() end} }

    local player = game:GetService("Players").LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    local screen = Instance.new("ScreenGui")
    screen.Name = "TekscriptsDialog"
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.ResetOnSpawn = false
    screen.Parent = PlayerGui

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    -- O overlay será registrado separadamente para recalcular sua transparência
    overlay.BackgroundTransparency = 1 - DESIGN.WindowTransparency
    overlay.ZIndex = 999 
    overlay.Parent = screen
    
    -- Função auxiliar para o overlay, que usa 1 - DESIGN.WindowTransparency
    local function updateOverlayTransparency()
        if overlay and overlay.Parent then
            overlay.BackgroundTransparency = 1 - DESIGN.WindowTransparency
        end
    end
    -- Registra o overlay em uma chave customizada para a transparência
    RegisterThemeItem("WindowTransparency", {object = {BackgroundTransparency = overlay.BackgroundTransparency}, property = "BackgroundTransparency"}, updateOverlayTransparency)


    local box = Instance.new("Frame")
    box.Name = "DialogBox"
    box.Size = UDim2.new(0, 340, 0, 0)
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
    box.BackgroundColor3 = DESIGN.ComponentBackground
    RegisterThemeItem("WindowTransparency", box, "BackgroundTransparency")
    box.BackgroundTransparency = DESIGN.WindowTransparency 
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.ZIndex = 1000
    box.Parent = screen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    corner.Parent = box

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, DESIGN.ComponentPadding)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = box

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, DESIGN.TitlePadding)
    padding.PaddingBottom = UDim.new(0, DESIGN.TitlePadding)
    padding.PaddingLeft = UDim.new(0, DESIGN.ComponentPadding)
    padding.PaddingRight = UDim.new(0, DESIGN.ComponentPadding)
    padding.Parent = box

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = titleText
    title.Size = UDim2.new(1, 0, 0, DESIGN.TitleHeight)
    title.BackgroundTransparency = 1
    RegisterThemeItem("TitleColor", title, "TextColor3")
    title.TextColor3 = DESIGN.TitleColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.ZIndex = 1001
    title.LayoutOrder = 1
    title.Parent = box

    local hr = Instance.new("Frame")
    hr.Name = "TitleDivider"
    hr.Size = UDim2.new(1, 0, 0, 2)
    RegisterThemeItem("DividerColor", hr, "BackgroundColor3")
    hr.BackgroundColor3 = DESIGN.DividerColor or Color3.fromRGB(200,200,200)
    hr.BorderSizePixel = 0
    hr.ZIndex = 1001
    hr.LayoutOrder = 2
    hr.Parent = box

    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Text = messageText
    message.Size = UDim2.new(1, 0, 0, 0)
    message.AutomaticSize = Enum.AutomaticSize.Y
    message.BackgroundTransparency = 1
    message.TextWrapped = true
    RegisterThemeItem("ComponentTextColor", message, "TextColor3")
    message.TextColor3 = DESIGN.ComponentTextColor
    message.Font = Enum.Font.Gotham
    message.TextSize = 14
    message.TextXAlignment = Enum.TextXAlignment.Center
    message.TextYAlignment = Enum.TextYAlignment.Center
    message.ZIndex = 1001
    message.LayoutOrder = 3
    message.Parent = box

    local buttonHolder = Instance.new("Frame")
    buttonHolder.Name = "ButtonHolder"
    buttonHolder.Size = UDim2.new(1, 0, 0, 36)
    buttonHolder.BackgroundTransparency = 1
    buttonHolder.LayoutOrder = 4
    buttonHolder.ZIndex = 1001
    buttonHolder.Parent = box

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0, DESIGN.ComponentPadding)
    btnLayout.Parent = buttonHolder

    local connections = {}
    
    -- Lista de referências para forçar o re-hover (necessário quando o tema muda)
    local buttonsApi = {} 

    for i, btnInfo in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Name = btnInfo.Text or ("Button" .. i)
        btn.Size = UDim2.new(0, 100, 0, 30)
        
        RegisterThemeItem("InputBackgroundColor", btn, "BackgroundColor3")
        RegisterThemeItem("InputTextColor", btn, "TextColor3")
        
        btn.BackgroundColor3 = DESIGN.InputBackgroundColor
        btn.TextColor3 = DESIGN.InputTextColor
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Text = btnInfo.Text or "Button"
        btn.ZIndex = 1002
        btn.AutoButtonColor = false
        btn.Parent = buttonHolder

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, DESIGN.CornerRadius / 2)
        btnCorner.Parent = btn

        local function mouseEnter()
            btn.BackgroundColor3 = DESIGN.ComponentHoverColor
        end
        local function mouseLeave()
            btn.BackgroundColor3 = DESIGN.InputBackgroundColor
        end
        
        local enterConn = btn.MouseEnter:Connect(mouseEnter)
        local leaveConn = btn.MouseLeave:Connect(mouseLeave)

        table.insert(connections, enterConn)
        table.insert(connections, leaveConn)
        
        -- API interna do botão para forçar o Leave/Re-apply
        local buttonApi = {
            instance = btn,
            reapplyTheme = function()
                mouseLeave() -- Força o botão para a cor normal (InputBackgroundColor)
            end
        }
        table.insert(buttonsApi, buttonApi)
        
        RegisterThemeItem("ComponentHoverColor", buttonApi, "reapplyTheme")

        table.insert(connections, btn.MouseButton1Click:Connect(function()
            if btnInfo.Callback then pcall(btnInfo.Callback) end
            screen:Destroy()
        end))
    end

    local api = {
        _screen = screen,
        _connections = connections
    }

    function api:Destroy()
        for _, c in ipairs(connections) do
            if c.Connected then c:Disconnect() end
        end
        screen:Destroy()
    end

    return api
end

function Tekscripts:CreateInput(tab, options)
	assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateInput")
	assert(type(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateInput")

	local TweenService = game:GetService("TweenService")

	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight + 30)
	RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
	box.BackgroundColor3 = DESIGN.ComponentBackground
	box.BackgroundTransparency = DESIGN.TabContainerTransparency
	box.Parent = tab.Container
	addRoundedCorners(box, DESIGN.CornerRadius)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = box

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = box

	local topRow = Instance.new("Frame")
	topRow.Size = UDim2.new(1, 0, 0, 28)
	topRow.BackgroundTransparency = 1
	topRow.Parent = box

	local rowLayout = Instance.new("UIListLayout")
	rowLayout.FillDirection = Enum.FillDirection.Horizontal
	rowLayout.Padding = UDim.new(0, 6)
	rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rowLayout.Parent = topRow

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.4, 0, 1, 0)
	title.BackgroundTransparency = 1
	title.Text = options.Text
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	RegisterThemeItem("ComponentTextColor", title, "TextColor3")
	title.TextColor3 = DESIGN.ComponentTextColor
	title.Parent = topRow

	local textbox = Instance.new("TextBox")
	textbox.Size = UDim2.new(0.6, 0, 1, 0)
	RegisterThemeItem("InputBackgroundColor", textbox, "BackgroundColor3")
	textbox.BackgroundColor3 = DESIGN.InputBackgroundColor
	textbox.PlaceholderText = options.Placeholder or ""
	textbox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
	RegisterThemeItem("InputTextColor", textbox, "TextColor3")
	textbox.TextColor3 = DESIGN.InputTextColor
	textbox.TextScaled = true
	textbox.Font = Enum.Font.Roboto
	textbox.TextXAlignment = Enum.TextXAlignment.Left
	textbox.TextYAlignment = Enum.TextYAlignment.Center
	textbox.BorderSizePixel = 0
	textbox.Text = ""
	textbox.ClipsDescendants = true
	textbox.Parent = topRow
	addRoundedCorners(textbox, DESIGN.CornerRadius)
	local hoverConnections = addHoverEffect(textbox, DESIGN.InputBackgroundColor, DESIGN.InputHoverColor)

	local blockOverlay = Instance.new("Frame")
	blockOverlay.Size = UDim2.new(1, 0, 1, 0)
	blockOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blockOverlay.BackgroundTransparency = 0.35
	blockOverlay.Visible = false
	blockOverlay.ZIndex = textbox.ZIndex + 2
	addRoundedCorners(blockOverlay, DESIGN.CornerRadius)
	blockOverlay.Parent = textbox

	local blockText = Instance.new("TextLabel")
	blockText.AnchorPoint = Vector2.new(0.5, 0.5)
	blockText.Position = UDim2.new(0.5, 0, 0.5, 0)
	blockText.Size = UDim2.new(1, -8, 1, -8)
	blockText.BackgroundTransparency = 1
	blockText.Text = options.BlockText or "🔒 BLOQUEADO"
	blockText.Font = Enum.Font.GothamBold
	blockText.TextScaled = true
	blockText.TextColor3 = Color3.fromRGB(255, 85, 85)
	blockText.ZIndex = blockOverlay.ZIndex + 1
	blockText.Parent = blockOverlay

	local errorIndicator = Instance.new("Frame")
	errorIndicator.Size = UDim2.new(0, 8, 0, 8)
	errorIndicator.Position = UDim2.new(1, -10, 0, 2)
	errorIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	errorIndicator.Visible = false
	errorIndicator.ZIndex = textbox.ZIndex + 3
	addRoundedCorners(errorIndicator, 100)
	errorIndicator.Parent = textbox

	local desc
	if options.Desc then
		desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, 0, 0, 14)
		desc.BackgroundTransparency = 1
		desc.Text = options.Desc
		desc.Font = Enum.Font.Gotham
		desc.TextScaled = true
		desc.TextWrapped = true
		desc.TextXAlignment = Enum.TextXAlignment.Left
		-- Não registramos diretamente, mas dependemos da ComponentTextColor, garantindo a tonalidade
		desc.TextColor3 = DESIGN.ComponentTextColor:lerp(Color3.new(0.7, 0.7, 0.7), 0.6)
		desc.Parent = box
	end

	local connections = {}
	local publicApi = { _instance = box, _connections = connections, Blocked = false, _hoverConnections = hoverConnections }
	local inError = false
	
	-- Função para reaplicar hover após tema. Assume que addHoverEffect tem um destrutor/reaplicador interno
	local function reapplyHoverEffect()
		if publicApi._hoverConnections then
			for _, conn in pairs(publicApi._hoverConnections) do
				if conn and conn.Connected then conn:Disconnect() end
			end
		end
		-- Reaplica o efeito com as cores atuais do DESIGN
		publicApi._hoverConnections = addHoverEffect(textbox, DESIGN.InputBackgroundColor, DESIGN.InputHoverColor)
	end
	
	-- Adiciona o hook para reativar o hover após o tema mudar
	RegisterThemeItem("InputHoverColor", publicApi, "_reapplyHover")
	
	function publicApi:_reapplyHover()
	    reapplyHoverEffect()
	end


	local function pulseError()
		if not textbox then return end
		inError = true
		errorIndicator.Visible = true
		TweenService:Create(textbox, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(255, 60, 60) }):Play()
		task.delay(0.5, function()
			if textbox and not publicApi.Blocked then
				inError = false
				errorIndicator.Visible = false
				-- Usa DESIGN.InputBackgroundColor para reverter para a cor correta do tema atual
				TweenService:Create(textbox, TweenInfo.new(0.2), { BackgroundColor3 = DESIGN.InputBackgroundColor }):Play()
			end
		end)
	end

	local function safeCallback(value)
		if publicApi.Blocked or not options.Callback then return end
		local ok, err = pcall(function() options.Callback(value) end)
		if not ok then
			warn("[Input Error]:", err)
			pulseError()
		end
	end

	if options.Type and options.Type:lower() == "number" then
		connections.Changed = textbox:GetPropertyChangedSignal("Text"):Connect(function()
			if publicApi.Blocked then return end
			local newText = textbox.Text
			if tonumber(newText) or newText == "" or newText == "-" then
				safeCallback(tonumber(newText) or 0)
			else
				textbox.Text = newText:sub(1, #newText - 1)
			end
		end)
	else
		connections.FocusLost = textbox.FocusLost:Connect(function(enterPressed)
			if publicApi.Blocked then return end
			if enterPressed then safeCallback(textbox.Text) end
		end)
	end

	function publicApi:SetBlocked(state, text)
		self.Blocked = state
		textbox.Active = not state
		textbox.TextEditable = not state
		blockOverlay.Visible = state
		if text then blockText.Text = tostring(text) end
	end

	function publicApi:Update(newOptions)
		if not newOptions then return end
		if newOptions.Text then title.Text = newOptions.Text end
		if newOptions.Placeholder then textbox.PlaceholderText = newOptions.Placeholder end
		if newOptions.Desc then
			if desc then desc.Text = newOptions.Desc
			elseif newOptions.Desc ~= "" then
				desc = Instance.new("TextLabel")
				desc.Size = UDim2.new(1, 0, 0, 14)
				desc.BackgroundTransparency = 1
				-- Recria a cor do texto do desc
				desc.TextColor3 = DESIGN.ComponentTextColor:lerp(Color3.new(0.7, 0.7, 0.7), 0.6)
				desc.Font = Enum.Font.Gotham
				desc.TextScaled = true
				desc.TextWrapped = true
				desc.TextXAlignment = Enum.TextXAlignment.Left
				desc.Text = newOptions.Desc
				desc.Parent = box
			end
		end
		if newOptions.Value ~= nil then textbox.Text = tostring(newOptions.Value) end
		if newOptions.BlockText then blockText.Text = tostring(newOptions.BlockText) end
	end

	function publicApi:Destroy()
		if self._connections then
			for _, conn in pairs(self._connections) do
				if conn and conn.Connected then conn:Disconnect() end
			end
			self._connections = nil
		end
		if self._hoverConnections then
			for _, conn in pairs(self._hoverConnections) do
				if conn and conn.Connected then conn:Disconnect() end
			end
			self._hoverConnections = nil
		end
		if self._instance then
			self._instance:Destroy()
			self._instance = nil
		end
	end

	table.insert(tab.Components, publicApi)
	return publicApi
end


function Tekscripts:CreateButton(tab, options)
    assert(typeof(tab) == "table" and tab.Container, "CreateButton: 'tab' inválido ou sem Container.")
    assert(typeof(options) == "table" and typeof(options.Text) == "string", "CreateButton: 'options' inválido.")

    local TweenService = game:GetService("TweenService")

    local callback = typeof(options.Callback) == "function" and options.Callback or function() end
    local debounceTime = tonumber(options.Debounce or 0.25)
    local lastClick = 0
    
    local errorColor = Color3.fromRGB(255, 60, 60)
    
    local function getColors()
        return {
            btn = self._blocked and Color3.fromRGB(60, 60, 60) or DESIGN.ComponentBackground,
            hover = DESIGN.ComponentHoverColor
        }
    end

    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight)
    
    RegisterThemeItem("ComponentBackground", btn, "BackgroundColor3")
    btn.BackgroundColor3 = DESIGN.ComponentBackground
    
    btn.BackgroundTransparency = DESIGN.TabContainerTransparency
    
    RegisterThemeItem("ComponentTextColor", btn, "TextColor3")
    btn.TextColor3 = DESIGN.ComponentTextColor
    
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = options.Text
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    btn.Parent = tab.Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    RegisterThemeItem("HRColor", stroke, "Color")
    stroke.Color = DESIGN.HRColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    local function tweenTo(props, duration)
        if not btn or not btn.Parent then return end
        local tween = TweenService:Create(btn, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad), props)
        tween:Play()
        return tween
    end

    local function pulseError()
        tweenTo({BackgroundColor3 = errorColor}, 0.1)
        task.delay(0.2, function()
            tweenTo({BackgroundColor3 = getColors().btn}, 0.2)
        end)
    end

    local hoverConn = btn.MouseEnter:Connect(function()
        if not self._blocked then tweenTo({BackgroundColor3 = getColors().hover}) end
    end)

    local leaveConn = btn.MouseLeave:Connect(function()
        if not self._blocked then tweenTo({BackgroundColor3 = getColors().btn}) end
    end)

    local clickConn = btn.MouseButton1Click:Connect(function()
        if self._blocked then return end
        if tick() - lastClick < debounceTime then return end
        lastClick = tick()

        tweenTo({Size = UDim2.new(0.95, 0, 0, DESIGN.ComponentHeight * 0.9)}, 0.1)
        task.delay(0.1, function()
            tweenTo({Size = UDim2.new(1, 0, 0, DESIGN.ComponentHeight)}, 0.1)
        end)

        task.spawn(function()
            local ok, err = pcall(callback)
            if not ok then
                warn("[CreateButton] Callback error:", err)
                pulseError()
                if Tekscripts.Log then
                    Tekscripts.Log("[Button Error] " .. tostring(err))
                end
            end
        end)
    end)

    local publicApi = {
        _instance = btn,
        _connections = {clickConn, hoverConn, leaveConn},
        _blocked = false,
        _callback = callback,
        -- Adicionando método para forçar a reaplicação de cor em caso de troca de tema
        _reapplyTheme = function() 
            if not self._blocked then
                -- Força a cor normal do botão
                tweenTo({BackgroundColor3 = getColors().btn}, 0.1) 
            end
        end
    }

    function publicApi:SetBlocked(state)
        self._blocked = state
        self._instance.Active = not state
        local color = getColors().btn
        tweenTo({BackgroundColor3 = color}, 0.15)
    end

    function publicApi:Update(newOptions)
        if typeof(newOptions) ~= "table" then return end
        if newOptions.Text then btn.Text = tostring(newOptions.Text) end
        if typeof(newOptions.Callback) == "function" then
            callback = newOptions.Callback
            self._callback = callback
        end
        if newOptions.Debounce then
            debounceTime = tonumber(newOptions.Debounce)
        end
    end

    function publicApi:Destroy()
        for _, c in ipairs(self._connections) do
            if c.Connected then c:Disconnect() end
        end
        if self._instance then
            self._instance:Destroy()
        end
        self._connections = nil
        self._instance = nil
        self._callback = nil
        setmetatable(self, nil)
        table.clear(self)
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateFloatButton(options)
    assert(typeof(options) == "table" and type(options.Text) == "string", "Invalid arguments for CreateFloatButton")

    local Text = options.Text or "Button"
    local Title = options.Title or "Arraste aqui" -- cabeçote
    local Drag = options.Drag ~= false -- default true
    local Visible = options.Visible ~= false -- default true
    local Pos = options.Pos or UDim2.new(0.5, 0, 0.5, 0)
    local Callback = typeof(options.Callback) == "function" and options.Callback or function() end

    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Verifica se já existe um ScreenGui para FloatButtons
    local screenGui = playerGui:FindFirstChild("TekscriptsFloatGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "TekscriptsFloatGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
    end

    -- Container do botão flutuante
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 120, 0, Drag and 60 or 40) -- aumenta se tiver cabeçote
    container.Position = Pos
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundTransparency = 1
    container.Visible = Visible
    container.Parent = screenGui

    -- Cabeçote para arrastar
    local header
    if Drag then
        header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, 0, 0, 20)
        header.Position = UDim2.new(0, 0, 0, 0)
        header.Text = Title
        header.Font = Enum.Font.Gotham
        header.TextSize = 12
        header.TextColor3 = DESIGN.ComponentTextColor
        header.BackgroundColor3 = DESIGN.InputBackgroundColor
        header.Parent = container

        local cornerHeader = Instance.new("UICorner")
        cornerHeader.CornerRadius = UDim.new(0, DESIGN.CornerRadius / 2)
        cornerHeader.Parent = header
    end

    -- Botão principal
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = Drag and UDim2.new(0, 0, 0, 20) or UDim2.new(0, 0, 0, 0)
    button.Text = Text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BackgroundColor3 = DESIGN.InputBackgroundColor
    button.TextColor3 = DESIGN.InputTextColor
    button.AutoButtonColor = false
    button.Parent = container

    local cornerButton = Instance.new("UICorner")
    cornerButton.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    cornerButton.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = DESIGN.HRColor
    stroke.Parent = button

    -- Overlay para bloquear interações
    local overlay = Instance.new("Frame")
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.5
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.Visible = false
    overlay.Parent = button

    --- Lógica de Drag Aprimorada (Desktop e Mobile)
    local dragConnection = nil
    local dragStartOffset = Vector2.new(0, 0)
    
    -- Função auxiliar para restringir a posição (Clamping)
    local function clampPosition(position)
        local parentSize = container.Parent.AbsoluteSize
        local containerSize = container.AbsoluteSize
        local containerAnchor = container.AnchorPoint
        
        -- A posição que estamos trabalhando é o centro do frame (por causa do AnchorPoint)
        local minX = containerAnchor.X * containerSize.X
        local minY = containerAnchor.Y * containerSize.Y
        
        local maxX = parentSize.X - ((1 - containerAnchor.X) * containerSize.X)
        local maxY = parentSize.Y - ((1 - containerAnchor.Y) * containerSize.Y)
        
        -- Garante que a posição Absoluta fique dentro dos limites
        local clampedX = math.clamp(position.X, minX, maxX)
        local clampedY = math.clamp(position.Y, minY, maxY)

        -- Converte a posição Absoluta de volta para UDim2
        local scaleX = clampedX / parentSize.X
        local scaleY = clampedY / parentSize.Y
        
        return UDim2.new(scaleX, 0, scaleY, 0)
    end
    
    local function getScreenVector2(input)
        -- Tenta usar Position, mas converte o Vector3 para Vector2.
        -- Para GUIs, a posição é Vector2(X, Y), ignorando Z.
        return Vector2.new(input.Position.X, input.Position.Y)
    end
    
    local function onInputChanged(input)
        -- Deve ser o MouseMovement ou o Touch que começou o drag
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            
            -- ✅ CORREÇÃO FINAL: Usa a função auxiliar para garantir Vector2.
            local currentScreenPosition = getScreenVector2(input)
            
            -- A nova posição absoluta do *centro* do container é: 
            -- Posição atual do input - offset inicial (do clique/toque ao centro)
            local newAbsoluteCenter = currentScreenPosition - dragStartOffset
            
            local clampedPosition = clampPosition(newAbsoluteCenter)
            container.Position = clampedPosition
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragConnection then
                dragConnection:Disconnect()
                dragConnection = nil
            end
        end
    end

    if Drag and header then
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                
                -- ✅ CORREÇÃO FINAL: Usa a função auxiliar para garantir Vector2.
                local currentScreenPosition = getScreenVector2(input)
                
                -- Calcula o offset do clique em relação ao *centro* do Container (ponto definido por .Position)
                local absoluteCenter = container.AbsolutePosition + container.AbsoluteSize * container.AnchorPoint
                dragStartOffset = currentScreenPosition - absoluteCenter -- Usa o Vector2

                -- Desconecta qualquer conexão de arrasto anterior
                if dragConnection then
                    dragConnection:Disconnect()
                end

                -- Conecta o InputChanged para rastrear o movimento
                dragConnection = UserInputService.InputChanged:Connect(onInputChanged)
                
                -- Conecta o InputEnded para parar o arrasto
                local inputEndedConnection
                inputEndedConnection = UserInputService.InputEnded:Connect(function(endInput)
                    onInputEnded(endInput)
                    -- Desconecta o InputEnded assim que ele for disparado
                    if inputEndedConnection then
                        inputEndedConnection:Disconnect()
                    end
                end)
            end
        end)
    end
    
    -- Clique chama callback
    button.MouseButton1Click:Connect(function()
        pcall(Callback)
    end)

    -- API pública
    local api = {}

    function api:SetBlock(state)
        overlay.Visible = state
    end

    function api:SetText(newText)
        if typeof(newText) == "string" then
            button.Text = newText
        end
    end

    function api:SetTitle(newTitle)
        if Drag and typeof(newTitle) == "string" then
            header.Text = newTitle
        end
    end

    function api:SetVisible(state)
        container.Visible = state
    end

    function api:Destroy()
        container:Destroy()
    end

    -- Registro de cores no tema
    -- *Presumi que 'RegisterThemeItem' e 'DESIGN' estão definidos em outro local*
    if typeof(RegisterThemeItem) == "function" and typeof(DESIGN) == "table" then
        RegisterThemeItem("InputBackgroundColor", button, "BackgroundColor3")
        RegisterThemeItem("InputTextColor", button, "TextColor3")
        RegisterThemeItem("HRColor", stroke, "Color")
        if header then
            RegisterThemeItem("InputBackgroundColor", header, "BackgroundColor3")
            RegisterThemeItem("ComponentTextColor", header, "TextColor3")
        end
    end

    return api
end

--// Adicionando o sistema de tradução direto dentro do Tekscripts
Tekscripts.Localization = {
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    CurrentLanguage = "en",
    Translations = {},

    -- API
    Init = function(self, translations)
        if type(translations) == "table" then
            self.Translations = translations
        end
    end,

    SetLanguage = function(self, lang)
        if self.Translations[lang] then
            self.CurrentLanguage = lang
        else
            warn("Idioma não encontrado: "..tostring(lang))
        end
    end,

    GetLanguage = function(self)
        return self.CurrentLanguage
    end,

    SetTranslations = function(self, lang, translations)
        if type(translations) ~= "table" then return end
        self.Translations[lang] = self.Translations[lang] or {}
        for k,v in pairs(translations) do
            self.Translations[lang][k] = v
        end
    end,

    Get = function(self, key)
        if not self.Enabled then return key end
        if type(key) == "string" and key:sub(1,#self.Prefix) == self.Prefix then
            key = key:sub(#self.Prefix+1)
        end
        local lang = self.CurrentLanguage
        local t = self.Translations[lang] or self.Translations[self.DefaultLanguage]
        return (t and t[key]) or key
    end,

    TranslateText = function(self, text)
        if type(text) ~= "string" then return text end
        if text:sub(1, #self.Prefix) == self.Prefix then
            return self:Get(text)
        end
        return text
    end,

    SetEnabled = function(self, state)
        self.Enabled = state and true or false
    end
}

function Tekscripts:CreateSection(tab: any, options: { Title: string?, Open: boolean?, Fixed: boolean? })
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateSection")

    local DESIGN = DESIGN or {}
    local titleHeight = 45 -- Aumentado para dar mais presença
    local minClosedHeight = titleHeight -- A altura mínima agora é igual à altura do título
    local contentPadding = 10 

    local TweenService = game:GetService("TweenService")

    -- Container principal da section
    local sectionContainer = Instance.new("Frame")
    RegisterThemeItem("ComponentBackground", sectionContainer, "BackgroundColor3")
    sectionContainer.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(30, 30, 30)
    sectionContainer.BackgroundTransparency = DESIGN.TabContainerTransparency or 0
    sectionContainer.BorderSizePixel = 0
    sectionContainer.ClipsDescendants = true
    sectionContainer.Parent = tab.Container

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = sectionContainer

    -- Frame do título
    local titleFrame = Instance.new("Frame")
    titleFrame.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(40, 40, 40)
    titleFrame.BackgroundTransparency = 0.2 -- estado inicial normal
    titleFrame.Size = UDim2.new(1, 0, 0, titleHeight) -- Tamanho atualizado (45)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    titleFrame.ZIndex = 2
    titleFrame.Active = true
    titleFrame.Parent = sectionContainer

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleFrame

    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = options.Title or ""
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18 -- tamanho inicial normal
    RegisterThemeItem("ComponentTextColor", titleLabel, "TextColor3")
    titleLabel.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(230, 230, 230) -- cor inicial normal
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -50, 0, 20) -- Ajustado o X para deixar espaço para seta
    
    -- Ajuste para centralizar verticalmente no frame de 45 de altura: (45 - 20) / 2 = 12.5
    titleLabel.Position = UDim2.new(0, 10, 0.5, -10) -- UDim2(0, 10, 0.5, -10) (0.5 é 50% do Y, -10 é metade de 20px)
    
    titleLabel.ZIndex = 3
    titleLabel.Parent = titleFrame

    -- Indicador de seta
    local arrowLabel = Instance.new("TextLabel")
    arrowLabel.Text = "▼"
    arrowLabel.Font = Enum.Font.GothamBold
    arrowLabel.TextSize = 14
    RegisterThemeItem("ComponentTextColor", arrowLabel, "TextColor3")
    arrowLabel.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(230, 230, 230) -- cor inicial normal
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Size = UDim2.new(0, 20, 0, 20)
    
    -- Ajuste para centralizar verticalmente no frame de 45 de altura: (45 - 20) / 2 = 12.5
    arrowLabel.Position = UDim2.new(1, -25, 0.5, -10) -- UDim2(1, -25, 0.5, -10)
    
    arrowLabel.ZIndex = 3
    arrowLabel.Parent = titleFrame
    arrowLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Linha separadora
    local separatorLine = Instance.new("Frame")
    RegisterThemeItem("HRColor", separatorLine, "BackgroundColor3")
    separatorLine.BackgroundColor3 = DESIGN.HRColor or Color3.fromRGB(100, 100, 100)
    separatorLine.Size = UDim2.new(1, -20, 0, 1)
    separatorLine.Position = UDim2.new(0, 10, 0, titleHeight - 1)
    separatorLine.BorderSizePixel = 0
    separatorLine.ZIndex = 2
    separatorLine.Parent = sectionContainer

    -- Lógica de Hover
    local function setHover(state)
        local targetTransparency = state and 0 or 0.2
        local targetTextSize = state and 20 or 18
        local targetColor = state and (DESIGN.ComponentHoverColor or Color3.fromRGB(200, 200, 200))
                            or (DESIGN.ComponentTextColor or Color3.fromRGB(230, 230, 230))
        
        -- Garante que o estado inicial (false) use as cores normais
        TweenService:Create(titleFrame, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { BackgroundTransparency = targetTransparency }):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { TextSize = targetTextSize, TextColor3 = targetColor }):Play()
        TweenService:Create(arrowLabel, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { TextColor3 = targetColor }):Play()
    end

    titleFrame.MouseEnter:Connect(function() setHover(true) end)
    titleFrame.MouseLeave:Connect(function() setHover(false) end)

    -- Container interno
    local contentContainer = Instance.new("Frame")
    contentContainer.BackgroundTransparency = 1
    contentContainer.Size = UDim2.new(1, -20, 1, -titleHeight)
    contentContainer.Position = UDim2.new(0, 10, 0, titleHeight)
    contentContainer.Parent = sectionContainer
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = contentContainer

    -- Overlay de bloqueio
    local blockOverlay = Instance.new("Frame")
    blockOverlay.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(20, 20, 20)
    blockOverlay.BackgroundTransparency = 0.6
    blockOverlay.Size = UDim2.new(1, 0, 0, 0)
    blockOverlay.Position = UDim2.new(0, 0, 0, titleHeight)
    blockOverlay.Visible = false
    blockOverlay.ZIndex = 5
    blockOverlay.Active = true
    blockOverlay.Parent = sectionContainer

    local overlayCorner = Instance.new("UICorner")
    overlayCorner.CornerRadius = UDim.new(0, 8)
    overlayCorner.Parent = blockOverlay

    local blockLabel = Instance.new("TextLabel")
    blockLabel.Text = "Bloqueado"
    blockLabel.Font = Enum.Font.GothamBold
    RegisterThemeItem("ComponentTextColor", blockLabel, "TextColor3")
    blockLabel.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(255, 255, 255)
    blockLabel.TextSize = 24
    blockLabel.BackgroundTransparency = 1
    blockLabel.Size = UDim2.new(1, 0, 1, 0)
    blockLabel.TextXAlignment = Enum.TextXAlignment.Center
    blockLabel.TextYAlignment = Enum.TextYAlignment.Center
    blockLabel.TextWrapped = true
    blockLabel.ZIndex = 6
    blockLabel.Parent = blockOverlay

    -- Atualiza overlay
    local sizeConnection = contentContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if blockOverlay.Visible then
            blockOverlay.Size = UDim2.new(1, 0, 0, contentContainer.AbsoluteSize.Y)
        end
    end)

    -- Estados
    local open = options.Open ~= false
    local fixed = options.Fixed == true

    local function updateHeight()
        local contentHeight = layout.AbsoluteContentSize.Y
        local targetOpenHeight = titleHeight + contentHeight + contentPadding
        local targetHeight = open and targetOpenHeight or minClosedHeight
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        TweenService:Create(sectionContainer, tweenInfo, { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
        local targetRotation = open and 180 or 0 
        TweenService:Create(arrowLabel, tweenInfo, { Rotation = targetRotation }):Play()

        if blockOverlay.Visible and open then
            blockOverlay.Size = UDim2.new(1, 0, 0, contentHeight)
        elseif not open then
            TweenService:Create(blockOverlay, tweenInfo, { Size = UDim2.new(1, 0, 0, 0) }):Play()
        end
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateHeight)
    task.defer(updateHeight)

    local publicApi = {
        _instance = sectionContainer,
        _content = contentContainer,
        Components = {},
        _blocked = false
    }

    function publicApi:_reapplyBackgrounds()
        titleFrame.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(40, 40, 40)
        blockOverlay.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(20, 20, 20)
    end

    RegisterThemeItem("ComponentBackground", publicApi, "_reapplyBackgrounds")

    -- API
    -- Função AddComponent atualizada para aceitar múltiplos argumentos
    function publicApi:AddComponent(...)
        local components = { ... } -- Captura todos os argumentos passados
        local added = false -- Flag para saber se algum componente foi adicionado
        
        for _, component in ipairs(components) do
            if component and component._instance then
                component._instance.Parent = contentContainer
                table.insert(publicApi.Components, component)
                added = true
            else
                warn("[Section] Componente inválido ou faltando '_instance' para AddComponent. Ignorando item:", component)
            end
        end

        if added then
            task.spawn(updateHeight) -- Atualiza a altura apenas uma vez, se componentes foram adicionados
        end
        -- Retorna a própria API para permitir chaining, se necessário (opcional)
        return publicApi 
    end

    function publicApi:SetTitle(text)
        titleLabel.Text = text or ""
    end

    function publicApi:Open()
        if fixed or open then return end
        open = true
        blockOverlay.Visible = publicApi._blocked 
        updateHeight()
    end

    function publicApi:Close()
        if fixed or not open then return end
        open = false
        updateHeight()
    end

    function publicApi:Toggle()
        if open then
            publicApi:Close()
        else
            publicApi:Open()
        end
    end

    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            publicApi:Toggle()
        end
    end)

    function publicApi:Block(state: boolean, message: string?)
        publicApi._blocked = state
        blockLabel.Text = message or "Bloqueado"
        blockOverlay.Visible = state and open
        if state and open then
            blockOverlay.Size = UDim2.new(1, 0, 0, contentContainer.AbsoluteSize.Y)
        elseif not state and not open then
            blockOverlay.Visible = false
        end
    end

    function publicApi:Destroy()
        if sizeConnection then
            sizeConnection:Disconnect()
        end
        for _, comp in ipairs(publicApi.Components) do
            if comp.Destroy then comp:Destroy() end
        end
        sectionContainer:Destroy()
    end

    table.insert(tab.Components, publicApi)
    return publicApi
end

function Tekscripts:CreateTabContainer(parentTab: any, options: { Title: string?, TabBarHeight: number? })
    assert(type(parentTab) == "table" and parentTab.Container, "Invalid parent Tab object provided to CreateTabContainer")

    local DESIGN = DESIGN or {}
    local tabHeight = options.TabBarHeight or 40
    local minTabWidth = 100
    local contentPadding = 10
    local TweenService = game:GetService("TweenService")

    -- Armazenamento das abas
    local tabs = {}
    local activeTab = nil

    -- Container principal da TabView
    local container = Instance.new("Frame")
    RegisterThemeItem("ComponentBackground", container, "BackgroundColor3")
    container.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(30, 30, 30)
    container.BackgroundTransparency = 0
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BorderSizePixel = 0
    container.Parent = parentTab.Container

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = container

    ---
    --- 1. BARRA VERTICAL DE ABAS (TOPO)
    ---

    local tabListContainer = Instance.new("ScrollingFrame")
    tabListContainer.BackgroundTransparency = 1
    tabListContainer.Size = UDim2.new(1, 0, 0, tabHeight)
    tabListContainer.Position = UDim2.new(0, 0, 0, 0)
    tabListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabListContainer.ScrollBarThickness = 6
    tabListContainer.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    tabListContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None
    tabListContainer.Parent = container

    RegisterThemeItem("HRColor", tabListContainer, "ScrollBarImageColor3")

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Parent = tabListContainer

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabListContainer.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X + 5, 0, 0)
    end)

    ---
    --- 2. CONTEÚDO PRINCIPAL (CONTENT)
    ---

    local contentContainer = Instance.new("Frame")
    contentContainer.BackgroundTransparency = 1
    contentContainer.Size = UDim2.new(1, 0, 1, -tabHeight)
    contentContainer.Position = UDim2.new(0, 0, 0, tabHeight)
    contentContainer.ClipsDescendants = true
    contentContainer.Parent = container

    ---
    --- LÓGICA DE GESTÃO DE ABAS
    ---

    local function switchToTab(tabName)
        local inactiveTextColor = DESIGN.ComponentTextColor or Color3.fromRGB(180, 180, 180)
        local activeTextColor = DESIGN.ComponentHoverColor or Color3.fromRGB(255, 255, 255)
        local activeBorderColor = DESIGN.HRColor or Color3.fromRGB(0, 120, 255)

        if activeTab and tabs[activeTab] then
            local prevTab = tabs[activeTab]

            -- Desativa o conteúdo da aba anterior
            prevTab.ContentFrame.Visible = false

            -- Desativa o estado visual do botão anterior
            -- A cor do texto desativa também.
            TweenService:Create(prevTab.Button, TweenInfo.new(0.15), { BackgroundTransparency = 1, TextColor3 = inactiveTextColor }):Play()

            -- Desativa a borda (UIStroke)
            if prevTab.Border then
                prevTab.Border.Enabled = false
            end
        end

        local newTab = tabs[tabName]
        if newTab then
            -- Ativa o conteúdo da nova aba
            newTab.ContentFrame.Visible = true

            -- Ativa o estado visual do novo botão
            -- O BackgroundTransparency é o preenchimento que você estava vendo.
            TweenService:Create(newTab.Button, TweenInfo.new(0.15), { BackgroundTransparency = 0.8, TextColor3 = activeTextColor }):Play()

            -- Ativa a borda (UIStroke)
            if newTab.Border then
                newTab.Border.Color = activeBorderColor
                newTab.Border.Enabled = true
            end

            activeTab = tabName
            newTab.Button.ZIndex = 3
        end
    end

    local function createTabButton(tabName)
        local button = Instance.new("TextButton")
        button.Name = tabName
        button.Text = tabName
        button.Font = Enum.Font.GothamBold
        button.TextSize = 16
        button.TextXAlignment = Enum.TextXAlignment.Center
        button.TextWrapped = true
        button.Size = UDim2.new(0, minTabWidth, 1, 0)

        -- Estilo Normal (Não Selecionado)
        button.BackgroundTransparency = 1
        RegisterThemeItem("ComponentTextColor", button, "TextColor3")
        button.TextColor3 = DESIGN.ComponentTextColor or Color3.fromRGB(180, 180, 180)
        RegisterThemeItem("ComponentBackground", button, "BackgroundColor3")
        button.BackgroundColor3 = DESIGN.ComponentBackground or Color3.fromRGB(40, 40, 40)

        -- ✅ SOLUÇÃO 1.1: Adiciona UICorner para bordas suaves no botão
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6) -- Ajuste para o valor que você preferir
        buttonCorner.Parent = button

        -- ✅ SOLUÇÃO 1.2: Adiciona UIStroke para a borda
        local buttonBorder = Instance.new("UIStroke")
        buttonBorder.Thickness = 1
        -- Muda o ApplyStrokeMode para Border. Isso faz o stroke envolver todo o perímetro do botão.
        buttonBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        RegisterThemeItem("HRColor", buttonBorder, "Color")
        buttonBorder.Enabled = false
        buttonBorder.Parent = button

        -- Padding do Texto
        local textPadding = Instance.new("UIPadding")
        textPadding.PaddingLeft = UDim.new(0, 5)
        textPadding.PaddingRight = UDim.new(0, 5)
        textPadding.Parent = button

        -- Lógica de Hover (Visual)
        local hoverColor = DESIGN.ComponentHoverColor or Color3.fromRGB(200, 200, 200)
        local inactiveTextColor = DESIGN.ComponentTextColor or Color3.fromRGB(180, 180, 180)

        button.MouseEnter:Connect(function()
            -- ✅ SOLUÇÃO 2: Só aplica o HOVER se a aba NÃO for a aba ativa
            if tabName ~= activeTab then
                TweenService:Create(button, TweenInfo.new(0.1), { BackgroundTransparency = 0.9, TextColor3 = hoverColor }):Play()
            end
        end)

        button.MouseLeave:Connect(function()
            -- ✅ SOLUÇÃO 2: Só remove o HOVER se a aba NÃO for a aba ativa
            if tabName ~= activeTab then
                TweenService:Create(button, TweenInfo.new(0.1), { BackgroundTransparency = 1, TextColor3 = inactiveTextColor }):Play()
            end
        end)

        -- Lógica de Clique
        button.MouseButton1Click:Connect(function()
            switchToTab(tabName)
        end)

        button.Parent = tabListContainer

        -- Retorna o botão E a borda (UIStroke)
        return button, buttonBorder
    end

    ---
    --- API PÚBLICA DO CONTAINER DE ABAS
    ---

    local publicApi = {
        _instance = container,
        Tabs = {}
    }

    function publicApi:AddTab(tabName: string, icon: string?)
        -- Verifica se a tab já existe
        if tabs[tabName] then
            warn("Tab '" .. tabName .. "' já existe.")
            return tabs[tabName].PublicAPI
        end

        -- 1. Cria o frame de conteúdo da aba (sem alterações aqui)
        local tabContentFrame = Instance.new("ScrollingFrame")
        tabContentFrame.BackgroundTransparency = 1
        tabContentFrame.Size = UDim2.new(1, 0, 1, 0)
        tabContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContentFrame.ScrollBarThickness = 6
        tabContentFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        tabContentFrame.Visible = false
        tabContentFrame.Parent = contentContainer

        RegisterThemeItem("HRColor", tabContentFrame, "ScrollBarImageColor3")

        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Padding = UDim.new(0, 5)
        tabContentLayout.Parent = tabContentFrame

        tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContentFrame.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y + contentPadding)
        end)

        -- 2. Cria o botão da aba e a Borda
        local tabButton, buttonBorder = createTabButton(tabName)

        -- 3. Cria a API da Tab
        local tabApi = {
            _instance = tabContentFrame,
            Components = {},
        }

        -- Função AddComponent (suporta múltiplos)
        function tabApi:AddComponent(...)
            local components = { ... }
            local added = false

            for _, component in ipairs(components) do
                if component and component._instance then
                    component._instance.Parent = tabContentFrame
                    table.insert(tabApi.Components, component)
                    added = true
                else
                    warn("[TabContainer] Componente inválido ou faltando '_instance' para AddComponent na tab:", tabName)
                end
            end

            return tabApi
        end

        -- 4. Armazena e inicializa
        tabs[tabName] = {
            Button = tabButton,
            Border = buttonBorder,
            ContentFrame = tabContentFrame,
            PublicAPI = tabApi
        }

        -- Se for a primeira aba, ativa-a
        if not activeTab then
            switchToTab(tabName)
        end

        table.insert(publicApi.Tabs, tabApi)
        return tabApi
    end

    function publicApi:SwitchTo(tabName: string)
        if tabs[tabName] then
            switchToTab(tabName)
        else
            warn("Tab '" .. tabName .. "' não encontrada.")
        end
    end

    return publicApi
end

function Tekscripts:CreateLabel(tab, options)
    assert(type(tab) == "table" and tab.Container, "Objeto de Aba inválido")
    assert(type(options) == "table" and type(options.Title) == "string", "Opções inválidas")

    local HttpService = game:GetService("HttpService")
    local mode = options.imageGround or "min" -- "min", "medium", or "max"
    
    -- Configuração de tamanhos
    local IMAGE_SIZE = 40
    if mode == "medium" then IMAGE_SIZE = 55 end
    if mode == "max" then IMAGE_SIZE = 75 end

    local function loadExternalImage(url)
        local success, result = pcall(function()
            local filename = "img_" .. HttpService:GenerateGUID(false):gsub("-","") .. ".png"
            if not isfile(filename) then
                writefile(filename, game:HttpGet(url))
            end
            return (getsynasset or getcustomasset)(filename)
        end)
        return success and result or ""
    end

    -- 1. ESTRUTURA PRINCIPAL
    local outerBox = Instance.new("Frame")
    outerBox.Name = "Label_" .. options.Title
    outerBox.BorderSizePixel = 0
    outerBox.Size = UDim2.new(1, 0, 0, 0)
    outerBox.AutomaticSize = Enum.AutomaticSize.Y
    outerBox.Parent = tab.Container

    RegisterThemeItem("ComponentBackground", outerBox, "BackgroundColor3")
    outerBox.BackgroundTransparency = DESIGN.ComponentBackgroundTransparency or 0.2

    local uicorner = Instance.new("UICorner", outerBox)
    uicorner.CornerRadius = UDim.new(0, DESIGN.CornerRadius or 9)

    local uiPadding = Instance.new("UIPadding", outerBox)
    local pV = DESIGN.ComponentPadding or 10
    uiPadding.PaddingTop = UDim.new(0, pV)
    uiPadding.PaddingBottom = UDim.new(0, pV)
    uiPadding.PaddingLeft = UDim.new(0, pV)
    uiPadding.PaddingRight = UDim.new(0, pV)

    -- 2. CONTAINER DE CONTEÚDO (Sempre Horizontal para manter o ícone na esquerda)
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    contentFrame.Parent = outerBox

    local horizontalLayout = Instance.new("UIListLayout", contentFrame)
    horizontalLayout.FillDirection = Enum.FillDirection.Horizontal
    horizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
    horizontalLayout.Padding = UDim.new(0, 12)
    
    -- O SEGREDO: Centraliza a Imagem na altura total do Box
    -- Se for min, fica no topo. Se for medium/max, centraliza no meio da altura.
    horizontalLayout.VerticalAlignment = (mode == "min" and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center)

    -- 3. ELEMENTOS DINÂMICOS
    local imageLabel = nil
    local descLabel = nil
    
    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.AutomaticSize = Enum.AutomaticSize.Y
    textContainer.BackgroundTransparency = 1
    textContainer.Size = UDim2.new(1, -(IMAGE_SIZE + 12), 0, 0) 
    textContainer.LayoutOrder = 2
    textContainer.Parent = contentFrame

    local verticalLayout = Instance.new("UIListLayout", textContainer)
    verticalLayout.Padding = UDim.new(0, 2)
    -- Centraliza o texto verticalmente também para alinhar com a imagem grande
    verticalLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = tostring(options.Title)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = (mode == "max" and 15 or 14)
    titleLabel.TextColor3 = options.Color or Color3.fromRGB(240, 240, 245)
    titleLabel.TextWrapped = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Size = UDim2.new(1, 0, 0, 0)
    titleLabel.AutomaticSize = Enum.AutomaticSize.Y
    titleLabel.Parent = textContainer

    if not options.Color then
        RegisterThemeItem("ComponentTextColor", titleLabel, "TextColor3")
    end

    -- API
    local component = {}

    function component:SetText(val)
        titleLabel.Text = tostring(val or "")
    end

    function component:SetDescription(val)
        local text = tostring(val or "")
        if text == "" then
            if descLabel then descLabel.Visible = false end
            return
        end

        if not descLabel then
            descLabel = Instance.new("TextLabel")
            descLabel.Name = "Description"
            descLabel.BackgroundTransparency = 1
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextSize = 13
            descLabel.TextWrapped = true
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.Size = UDim2.new(1, 0, 0, 0)
            descLabel.AutomaticSize = Enum.AutomaticSize.Y
            descLabel.Parent = textContainer
            descLabel.TextColor3 = Color3.fromRGB(170, 170, 175) 
        end
        descLabel.Visible = true
        descLabel.Text = text
    end

    function component:SetImage(urlOrId)
        if not urlOrId or urlOrId == "" then
            if imageLabel then imageLabel.Visible = false end
            textContainer.Size = UDim2.new(1, 0, 0, 0)
            return
        end

        if not imageLabel then
            imageLabel = Instance.new("ImageLabel")
            imageLabel.Name = "Icon"
            imageLabel.Size = UDim2.new(0, IMAGE_SIZE, 0, IMAGE_SIZE) 
            imageLabel.BackgroundTransparency = 1
            imageLabel.ScaleType = Enum.ScaleType.Fit
            imageLabel.LayoutOrder = 1
            imageLabel.Parent = contentFrame
            
            local imgCorner = Instance.new("UICorner", imageLabel)
            imgCorner.CornerRadius = UDim.new(0, (mode == "max" and 10 or 6))
        end

        imageLabel.Visible = true
        if tostring(urlOrId):match("^https?://") then
            imageLabel.Image = loadExternalImage(urlOrId)
        else
            imageLabel.Image = urlOrId
        end
        
        textContainer.Size = UDim2.new(1, -(IMAGE_SIZE + 12), 0, 0)
    end

    function component:SetVisible(state)
        outerBox.Visible = state
    end

    if options.Desc then component:SetDescription(options.Desc) end
    if options.Image then component:SetImage(options.Image) end

    table.insert(tab.Components, outerBox)
    return component
end

function Tekscripts:CreateDivider(tab, options)
    assert(type(tab) == "table" and tab.Container, "Invalid Tab object provided to CreateDividerBox")

    local text = options and options.Text or "Título"
    local height = options and options.Height or 28
    local boxColor = options and options.Color or DESIGN.ComponentBackground
    local txtColor = options and options.TextColor or DESIGN.ComponentTextColor

    -- CONTAINER COMPATÍVEL COM UIListLayout
    local container = Instance.new("Frame")
    container.Name = "DividerBox"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, height + 10)

    -- BOX CENTRAL
    local box = Instance.new("Frame")
    box.Name = "Box"
    RegisterThemeItem("ComponentBackground", box, "BackgroundColor3")
    box.BackgroundColor3 = boxColor
    box.BorderSizePixel = 0
    box.Size = UDim2.new(1, -20, 0, height) -- Margens laterais de 10px
    box.Position = UDim2.new(0, 10, 0, 5)
    box.ClipsDescendants = true -- Impede que qualquer coisa vaze visualmente do box
    box.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, DESIGN.CornerRadius)
    corner.Parent = box

    -- PADDING INTERNO (Evita o texto colado nas bordas)
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = box

    -- TEXTO CENTRAL
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextScaled = true -- Faz o texto diminuir se for muito grande
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    RegisterThemeItem("ComponentTextColor", label, "TextColor3")
    label.TextColor3 = txtColor
    label.Size = UDim2.new(1, 0, 1, 0)
    label.ZIndex = 2 -- Garante que fique acima de qualquer fundo ou linha
    label.Parent = box

    -- LIMITADOR DE TAMANHO DE TEXTO
    -- Garante que o texto não fique gigante (máximo 15) mas possa diminuir
    local sizeConstraint = Instance.new("UITextSizeConstraint")
    sizeConstraint.MaxTextSize = 15
    sizeConstraint.MinTextSize = 8
    sizeConstraint.Parent = label

    -- API
    local api = {
        _instance = container,
        _box = box,
        _label = label,
    }

    function api:SetText(newText)
        label.Text = newText
    end

    function api:SetColor(newColor)
        box.BackgroundColor3 = newColor
    end

    function api:SetTextColor(newColor)
        label.TextColor3 = newColor
    end

    function api:Destroy()
        if container then
            container:Destroy()
        end
    end

    -- REGISTRAR COMPONENTE NA TAB
    table.insert(tab.Components, api)
    container.Parent = tab.Container

    return api
end


function Tekscripts:Notify(options)
    -- === 1. PARÂMETROS E CONFIGURAÇÕES ===
    local Title = options.Title or options.Text or "Notificação"
    local Desc = options.Desc or "Sem descrição."
    local Duration = options.Duration or 5 
    local IconID = options.Icon
    local PosMode = options.Position or "Below" -- "Above" ou "Below"
    
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Camera = workspace.CurrentCamera
    
    -- Ajustes de Compactação (Mobile vs PC)
    local isSmallScreen = Camera.ViewportSize.X < 600
    local maxWidth = isSmallScreen and 230 or 270
    local textSizeTitle = isSmallScreen and 13 or 14
    local textSizeDesc = isSmallScreen and 11 or 12

    -- === 2. HOLDER DINÂMICO ===
    local NotificationsHolder = (function()
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local container = PlayerGui:FindFirstChild("TekScriptsNotifications_" .. PosMode)
        
        if not container then
            container = Instance.new("ScreenGui", PlayerGui)
            container.Name = "TekScriptsNotifications_" .. PosMode
            container.IgnoreGuiInset = true
            container.DisplayOrder = 2147483647 
            
            local holder = Instance.new("Frame", container)
            holder.Name = "Holder"
            holder.BackgroundTransparency = 1
            
            -- Lógica de Posicionamento Vertical
            if PosMode == "Above" then
                holder.AnchorPoint = Vector2.new(1, 0)
                holder.Position = UDim2.new(1, -15, 0, 50) -- Topo Direito
            else
                holder.AnchorPoint = Vector2.new(1, 1)
                holder.Position = UDim2.new(1, -15, 1, -15) -- Baixo Direito
            end
            
            holder.Size = UDim2.new(0, maxWidth, 0.8, 0)
            
            local layout = Instance.new("UIListLayout", holder)
            -- Se for Above, as novas aparecem em cima. Se for Below, embaixo.
            layout.VerticalAlignment = (PosMode == "Above") and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            layout.Padding = UDim.new(0, 8)
            -- SortOrder garante que a ordem de criação dite a posição
            layout.SortOrder = Enum.SortOrder.Name 
        end
        return container.Holder
    end)()

    -- === 3. CONSTRUÇÃO DO CARD ===
    local box = Instance.new("CanvasGroup")
    -- Nomeamos com tick() para o UIListLayout organizar por ordem de tempo
    box.Name = tostring(tick())
    box.Size = UDim2.new(1, 0, 0, 0)
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.Position = UDim2.new(1.2, 0, 0, 0) 
    box.GroupTransparency = 1 
    box.Parent = NotificationsHolder
    
    RegisterThemeItem("NotifyBackground", box, "BackgroundColor3")
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    -- Borda sutil (Stroke)
    local stroke = Instance.new("UIStroke", box)
    stroke.Transparency = 0.85
    RegisterThemeItem("AccentColor", stroke, "Color")

    local contentFrame = Instance.new("Frame", box)
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    contentFrame.BackgroundTransparency = 1
    
    local padding = Instance.new("UIPadding", contentFrame)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)

    -- Conteúdo (Título + Desc)
    local titleLabel = Instance.new("TextLabel", contentFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.Text = Title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = textSizeTitle
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    RegisterThemeItem("TitleColor", titleLabel, "TextColor3")

    local descLabel = Instance.new("TextLabel", contentFrame)
    descLabel.Position = UDim2.new(0, 0, 0, 20)
    descLabel.Size = UDim2.new(1, 0, 0, 0)
    descLabel.AutomaticSize = Enum.AutomaticSize.Y
    descLabel.Text = Desc
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = textSizeDesc
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.BackgroundTransparency = 1
    RegisterThemeItem("NotifyTextColor", descLabel, "TextColor3")

    -- Barra de Progresso
    local barBG = Instance.new("Frame", box)
    barBG.Size = UDim2.new(1, 0, 0, 2)
    barBG.Position = UDim2.new(0, 0, 1, -2)
    barBG.BackgroundTransparency = 0.9
    
    local progressBar = Instance.new("Frame", barBG)
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    RegisterThemeItem("AccentColor", progressBar, "BackgroundColor3")

    -- === 4. ANIMAÇÕES ===
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    TweenService:Create(box, tweenInfo, { Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0 }):Play()
    TweenService:Create(progressBar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) }):Play()

    task.delay(Duration, function()
        if box and box.Parent then
            local fadeOut = TweenService:Create(box, tweenInfo, { 
                Position = UDim2.new(1.2, 0, 0, 0),
                GroupTransparency = 1 
            })
            fadeOut:Play()
            fadeOut.Completed:Connect(function() box:Destroy() end)
        end
    end)
end

return Tekscripts