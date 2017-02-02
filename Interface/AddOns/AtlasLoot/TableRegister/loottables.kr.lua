if (GetLocale() == "koKR") then
-- Translated by acemage
-- Last Updated: 6/28/2007
-- missing some boss names. 
-- names with the fuction 'BabbleFaction' cause problem if I change the name
-- so I left those in english.

--Invoke libraries
local BabbleFaction = LibStub("LibBabble-Faction-3.0"):GetLookupTable();

--Table of loot titles

    --Auch: Mana-Tombs
    AtlasLoot_TableNames["AuchManaPandemonius"][1] = "팬더모니우스";
    AtlasLoot_TableNames["AuchManaPandemoniusHEROIC"][1] = "팬더모니우스 (영웅)";
    AtlasLoot_TableNames["AuchManaTavarok"][1] = "타바로크";
    AtlasLoot_TableNames["AuchManaTavarokHEROIC"][1] = "타바로크 (영웅)";
    AtlasLoot_TableNames["AuchManaNexusPrince"][1] = "연합왕자 샤파르 ";
    AtlasLoot_TableNames["AuchManaNexusPrinceHEROIC"][1] = "연합왕자 샤파르 (영웅)";
    AtlasLoot_TableNames["AuchManaYor"][1] = "Yor";
    AtlasLoot_TableNames["AuchManaTrash"][1] = "일반몹 (마나무덤)";
    --Auch: Auchenai Crypts
    AtlasLoot_TableNames["AuchCryptsShirrak"][1] = "쉴라크";
    AtlasLoot_TableNames["AuchCryptsShirrakHEROIC"][1] = "쉴라크 (영웅)";
    AtlasLoot_TableNames["AuchCryptsExarch"][1] = "말라다르";
    AtlasLoot_TableNames["AuchCryptsExarchHEROIC"][1] = "말라다르 (영웅)";
    AtlasLoot_TableNames["AuchCryptsAvatar"][1] = "순교자의 화신";
    AtlasLoot_TableNames["AuchCryptsTrash"][1] = "일반몹 (아키나이 납골당)";
    --Auch: Sethekk Halls
    AtlasLoot_TableNames["AuchSethekkDarkweaver"][1] = "흑마술사 시스";
    AtlasLoot_TableNames["AuchSethekkDarkweaverHEROIC"][1] = "흑마술사 시스 (영웅)";
    AtlasLoot_TableNames["AuchSethekkTalonKing"][1] = "칼퀴대왕 이키스";
    AtlasLoot_TableNames["AuchSethekkTalonKingHEROIC"][1] = "칼퀴대왕 이키스 (영웅)";
    AtlasLoot_TableNames["AuchSethekkRavenGod"][1] = "Raven God Anzu";
    AtlasLoot_TableNames["AuchSethekkTrash"][1] = "일반몹 (세데크 전당)";
    --Auch: Shadow Labyrinth
    AtlasLoot_TableNames["AuchShadowHellmaw"][1] = "사자 지옥아귀";
    AtlasLoot_TableNames["AuchShadowHellmawHEROIC"][1] = "사자 지옥아귀 (영웅)";
    AtlasLoot_TableNames["AuchShadowBlackheart"][1] = "선동자 검은심장";
    AtlasLoot_TableNames["AuchShadowBlackheartHEROIC"][1] = "선동자 검은심장 (영웅)";
    AtlasLoot_TableNames["AuchShadowGrandmaster"][1] = "단장 보르필";
    AtlasLoot_TableNames["AuchShadowGrandmasterHEROIC"][1] = "단장 보르필 (영웅)";
    AtlasLoot_TableNames["AuchShadowMurmur"][1] = "울림";
    AtlasLoot_TableNames["AuchShadowMurmurHEROIC"][1] = "울림 (영웅)";
    AtlasLoot_TableNames["AuchShadowTrash"][1] = "일반몹 (어둠의 미궁)";
    --Blackfathom Deeps
    AtlasLoot_TableNames["BFDGhamoora"][1] = "가무라";
    AtlasLoot_TableNames["BFDLadySarevess"][1] = "여왕 사레베스";
    AtlasLoot_TableNames["BFDGelihast"][1] = "겔리하스트";
    AtlasLoot_TableNames["BFDBaronAquanis"][1] = "군주 아쿠아니스";
    AtlasLoot_TableNames["BFDTwilightLordKelris"][1] = "황혼의 군주 켈리스";
    AtlasLoot_TableNames["BFDOldSerrakis"][1] = "늙은 세라키스";
    AtlasLoot_TableNames["BFDAkumai"][1] = "아쿠마이";
    AtlasLoot_TableNames["BFDTrash"][1] = "일반몹 (검은 심연의 나락)";
    --Blackrock Depths
    AtlasLoot_TableNames["BRDLordRoccor"][1] = "불의 군주 록코르";
    AtlasLoot_TableNames["BRDHighInterrogatorGerstahn"][1] = "대심문관 게르스탄";
    AtlasLoot_TableNames["BRDArena"][1] = "법의 심판장";
    AtlasLoot_TableNames["BRDTheldren"][1] = "텔드렌";
    AtlasLoot_TableNames["BRDHoundmaster"][1] = "사냥개조련사 그렙마르";
    AtlasLoot_TableNames["BRDForgewright"][1] = "프랑클론 포지라이트의 기념비";
    AtlasLoot_TableNames["BRDPyromantLoregrain"][1] = "화염술사 로어그레인";
    AtlasLoot_TableNames["BRDWarderStilgiss"][1] = "검은 금고";
    AtlasLoot_TableNames["BRDFineousDarkvire"][1] = "파이너스 다크바이어";
    AtlasLoot_TableNames["BRDLordIncendius"][1] = "불의군주 인센디우스";
    AtlasLoot_TableNames["BRDBaelGar"][1] = "벨가르";
    AtlasLoot_TableNames["BRDGeneralAngerforge"][1] = "사령관 앵거포지";
    AtlasLoot_TableNames["BRDGolemLordArgelmach"][1] = "골렘군주 아젤마크";
    AtlasLoot_TableNames["BRDGuzzler"][1] = "험상궂은 주정뱅이";
    AtlasLoot_TableNames["BRDFlamelash"][1] = "사자 화염채찍";
    AtlasLoot_TableNames["BRDPanzor"][1] = "무적의 판저 (희귀)";
    AtlasLoot_TableNames["BRDTomb"][1] = "소환사의 무덤";
    AtlasLoot_TableNames["BRDLyceum"][1] = "어둠괴철로단 불꽃지기";
    AtlasLoot_TableNames["BRDMagmus"][1] = "마그무스";
    AtlasLoot_TableNames["BRDImperatorDagranThaurissan"][1] = "제왕 다그란 타우릿산";
    AtlasLoot_TableNames["BRDPrincess"][1] = "공주 모이라 브론즈비어드";
    AtlasLoot_TableNames["BRDPyron"][1] = "멸망의 파이론";
    AtlasLoot_TableNames["BRDTrash"][1] = "일반몹 (검은바위 나락)";
    --Lower Blackrock Spire
    AtlasLoot_TableNames["LBRSQuestItems"][1] = "검은바위산 하층 퀘스트 아이템";
    AtlasLoot_TableNames["LBRSSpirestoneButcher"][1] = "뾰족바위일족 도살자 (희귀)";
    AtlasLoot_TableNames["LBRSOmokk"][1] = "대군주 오모크";
    AtlasLoot_TableNames["LBRSSpirestoneLord"][1] = "뾰족바위일족 전투 지휘관 (희귀)";
    AtlasLoot_TableNames["LBRSLordMagus"][1] = "뽀족바위일족 군주 마구스 (희귀)";
    AtlasLoot_TableNames["LBRSVosh"][1] = "어둠사냥꾼 보쉬가진";
    AtlasLoot_TableNames["LBRSVoone"][1] = "대장군 부네";
    AtlasLoot_TableNames["LBRSGrayhoof"][1] = "모르 그레이후프 (소환)";
    AtlasLoot_TableNames["LBRSGrimaxe"][1] = "반노크 그림엑스 (희귀)";
    AtlasLoot_TableNames["LBRSSmolderweb"][1] = "여왕 불그물거미";
    AtlasLoot_TableNames["LBRSCrystalFang"][1] = "수정 맹독 거미";
    AtlasLoot_TableNames["LBRSDoomhowl"][1] = "우로크 둠하울 (소환)";
    AtlasLoot_TableNames["LBRSZigris"][1] = "병참장교 지그리스";
    AtlasLoot_TableNames["LBRSHalycon"][1] = "할리콘";
    AtlasLoot_TableNames["LBRSSlavener"][1] = "흉폭한 기즈롤";
    AtlasLoot_TableNames["LBRSBashguud"][1] = "고크 배시구드 (희귀)";
    AtlasLoot_TableNames["LBRSWyrmthalak"][1] = "대군주 웜타라크";
    AtlasLoot_TableNames["LBRSFelguard"][1] = "불타는 지옥수호병 (희귀, 렌덤)";
    AtlasLoot_TableNames["LBRSTrash"][1] = "일반몹 (검은바위 첨탑 하층)";
    --Upper Blackrock Spire
    AtlasLoot_TableNames["UBRSEmberseer"][1] = "불의 수호자 엠버시어";
    AtlasLoot_TableNames["UBRSSolakar"][1] = "화염고리 솔라카르";
    AtlasLoot_TableNames["UBRSFLAME"][1] = "태초의 불꽃";
    AtlasLoot_TableNames["UBRSRunewatcher"][1] = "제드 룬와쳐";
    AtlasLoot_TableNames["UBRSAnvilcrack"][1] = "고랄루크 앤빌크랙";
    AtlasLoot_TableNames["UBRSRend"][1] = "대족장 랜드 블랙핸드";
    AtlasLoot_TableNames["UBRSGyth"][1] = "기스";
    AtlasLoot_TableNames["UBRSBeast"][1] = "괴수";
    AtlasLoot_TableNames["UBRSValthalak"][1] = "군주 발타라크 (소환)";
    AtlasLoot_TableNames["UBRSDrakkisath"][1] = "사령관 드라키사스";
    AtlasLoot_TableNames["UBRSTrash"][1] = "일반몹 (검은바위산)";
    --The Black Temple
    AtlasLoot_TableNames["BTNajentus"][1] = "나젠투스";
    AtlasLoot_TableNames["BTSupremus"][1] = "수프레머스";
    AtlasLoot_TableNames["BTGorefiend"][1] = "테론 고어핀드";
    AtlasLoot_TableNames["BTBloodboil"][1] = "끓는 피의 구르토크";
    AtlasLoot_TableNames["BTAkama"][1] = "Shade of Akama";
    AtlasLoot_TableNames["BTEssencofSouls"][1] = "Essence of Souls";
    AtlasLoot_TableNames["BTShahraz"][1] = "대모 샤라즈";
    AtlasLoot_TableNames["BTCouncil"][1] = "Illidari Council";
    AtlasLoot_TableNames["BTIllidanStormrage"][1] = "일리단 스톰레이지";
    AtlasLoot_TableNames["BTTrash"][1] = "일반몹 (검은 사원)";
    --Blackwing Lair
    AtlasLoot_TableNames["BWLRazorgore"][1] = "폭군 서슬송곳니";
    AtlasLoot_TableNames["BWLVaelastrasz"][1] = "타락의 밸라스트라즈";
    AtlasLoot_TableNames["BWLLashlayer"][1] = "용기대장 레쉬레이어";
    AtlasLoot_TableNames["BWLFiremaw"][1] = "화염아귀";
    AtlasLoot_TableNames["BWLEbonroc"][1] = "에본로크";
    AtlasLoot_TableNames["BWLFlamegor"][1] = "플레임고르";
    AtlasLoot_TableNames["BWLChromaggus"][1] = "크로마구스";
    AtlasLoot_TableNames["BWLNefarian"][1] = "네파리안";
    AtlasLoot_TableNames["BWLTrashMobs"][1] = "일반몹 (검은날개둥지)";
    --CFR: Slave Pens
    AtlasLoot_TableNames["CFRSlaveMennu"][1] = "배반자 멘누";
    AtlasLoot_TableNames["CFRSlaveMennuHEROIC"][1] = "배반자 멘누 (영웅)";
    AtlasLoot_TableNames["CFRSlaveRokmar"][1] = "딱딱이 로크마르";
    AtlasLoot_TableNames["CFRSlaveRokmarHEROIC"][1] = "딱딱이 로크마르 (영웅)";
    AtlasLoot_TableNames["CFRSlaveQuagmirran"][1] = "쿠아그미란";
    AtlasLoot_TableNames["CFRSlaveQuagmirranHEROIC"][1] = "쿠아그미란 (영웅)";
    --CFR: The Steamvault
    AtlasLoot_TableNames["CFRSteamThespia"][1] = "풍수사 세스피아";
    AtlasLoot_TableNames["CFRSteamThespiaHEROIC"][1] = "풍수사 세스피아 (영웅)";
    AtlasLoot_TableNames["CFRSteamSteamrigger"][1] = "기계공학자 스팀리거";
    AtlasLoot_TableNames["CFRSteamSteamriggerHEROIC"][1] = "기계공학자 스팀리거 (영웅)";
    AtlasLoot_TableNames["CFRSteamWarlord"][1] = "장군 칼리스레쉬";
    AtlasLoot_TableNames["CFRSteamWarlordHEROIC"][1] = "장군 칼리스레쉬 (영웅)";
    AtlasLoot_TableNames["CFRSteamTrash"][1] = "일반몹 (증기 저장고)";
    --CFR: The Underbog
    AtlasLoot_TableNames["CFRUnderHungarfen"][1] = "헝가르펜";
    AtlasLoot_TableNames["CFRUnderHungarfenHEROIC"][1] = "헝가르펜 (영웅)";
    AtlasLoot_TableNames["CFRUnderGhazan"][1] = "가즈안";
    AtlasLoot_TableNames["CFRUnderGhazanHEROIC"][1] = "가즈안 (영웅)";
    AtlasLoot_TableNames["CFRUnderSwamplord"][1] = "늪군주 뮤즐레크";
    AtlasLoot_TableNames["CFRUnderSwamplordHEROIC"][1] = "늪군주 뮤즐레크 (영웅)";
    AtlasLoot_TableNames["CFRUnderStalker"][1] = "검은 추적자";
    AtlasLoot_TableNames["CFRUnderStalkerHEROIC"][1] = "검은 추적자 (영웅)";
    --CFR: Serpentshrine Cavern
    AtlasLoot_TableNames["CFRSerpentHydross"][1] = "불안정한 히드로스";
    AtlasLoot_TableNames["CFRSerpentKarathress"][1] = "심연의 군주 카라드레스";
    AtlasLoot_TableNames["CFRSerpentMorogrim"][1] = "겅둥파도 모로그림";
    AtlasLoot_TableNames["CFRSerpentLeotheras"][1] = "눈먼 레오테라스";
    AtlasLoot_TableNames["CFRSerpentLurker"][1] = "심연의 잠복꾼";
    AtlasLoot_TableNames["CFRSerpentVashj"][1] = "여군주 바쉬";
    AtlasLoot_TableNames["CFRSerpentTrash"][1] = "일반몹 (불뱀 제단)";
    --CoT: Old Hillsbrad Foothills
    AtlasLoot_TableNames["CoTHillsbradDrake"][1] = "부관 드레이크";
    AtlasLoot_TableNames["CoTHillsbradDrakeHEROIC"][1] = "부관 드레이크 (영웅)";
    AtlasLoot_TableNames["CoTHillsbradSkarloc"][1] = "경비대장 스칼록";
    AtlasLoot_TableNames["CoTHillsbradSkarlocHEROIC"][1] = "경비대장 스칼록 (영웅)";
    AtlasLoot_TableNames["CoTHillsbradHunter"][1] = "시대의 사냥꾼";
    AtlasLoot_TableNames["CoTHillsbradHunterHEROIC"][1] = "시대의 사냥꾼 (영웅)";
    AtlasLoot_TableNames["CoTHillsbradTrash"][1] = "일반몹 (옛 힐스브래드 구릉지)";
    --CoT: Black Morass
    AtlasLoot_TableNames["CoTMorassDeja"][1] = "시간의 군주 데자";
    AtlasLoot_TableNames["CoTMorassDejaHEROIC"][1] = "시간의 군주 데자 (영웅)";
    AtlasLoot_TableNames["CoTMorassTemporus"][1] = "템퍼루스";
    AtlasLoot_TableNames["CoTMorassTemporusHEROIC"][1] = "템퍼루스 (영웅)";
    AtlasLoot_TableNames["CoTMorassAeonus"][1] = "아에누스";
    AtlasLoot_TableNames["CoTMorassAeonusHEROIC"][1] = "아에누스 (영웅)";
    AtlasLoot_TableNames["CoTMorassTrash"][1] = "일반몹 (검은늪)";
    --CoT: Hyjal Summit
    AtlasLoot_TableNames["MountHyjalWinterchill"][1] = "리치 윈터칠";
    AtlasLoot_TableNames["MountHyjalAnetheron"][1] = "아네테론";
    AtlasLoot_TableNames["MountHyjalKazrogal"][1] = "카즈로갈";
    AtlasLoot_TableNames["MountHyjalAzgalor"][1] = "아즈칼로";
    AtlasLoot_TableNames["MountHyjalArchimonde"][1] = "아키몬드";
    --The Deadmines
    AtlasLoot_TableNames["VCRhahkZor"][1] = "라크조르";
    AtlasLoot_TableNames["VCMinerJohnson"][1] = "광부 존슨 (희귀)";
    AtlasLoot_TableNames["VCSneed"][1] = "스니드";
    AtlasLoot_TableNames["VCGilnid"][1] = "길니드";
    AtlasLoot_TableNames["VCCaptainGreenskin"][1] = "선장 그린스킨";
    AtlasLoot_TableNames["VCVanCleef"][1] = "에드윈 밴클리프";
    AtlasLoot_TableNames["VCMrSmite"][1] = "미스터 스마이트";
    AtlasLoot_TableNames["VCCookie"][1] = "주방장 쿠키";
    --Dire Maul East
    AtlasLoot_TableNames["DMEPusillin"][1] = "푸실린";
    AtlasLoot_TableNames["DMEZevrimThornhoof"][1] = "제브림 쏜후프";
    AtlasLoot_TableNames["DMEHydro"][1] = "히드로스폰";
    AtlasLoot_TableNames["DMELethtendris"][1] = "레스텐드리스";
    AtlasLoot_TableNames["DMEPimgib"][1] = "핌기브";
    AtlasLoot_TableNames["DMEAlzzin"][1] = "칼날바람 알진";
    AtlasLoot_TableNames["DMEIsalien"][1] = "이살리엔";
    AtlasLoot_TableNames["DMETrash"][1] = "일반몹 (혈투의 전장 - 동쪽)";
    AtlasLoot_TableNames["DMBooks"][1] = "혈장 책";
    --Dire Maul North
    AtlasLoot_TableNames["DMNGuardMoldar"][1] = "경비병 몰다르";
    AtlasLoot_TableNames["DMNStomperKreeg"][1] = "천둥발 크리그";
    AtlasLoot_TableNames["DMNGuardFengus"][1] = "경비병 펜구스";
    AtlasLoot_TableNames["DMNThimblejack"][1] = "노트 팀블젝";
    AtlasLoot_TableNames["DMNGuardSlipkik"][1] = "경비병 슬립킥";
    AtlasLoot_TableNames["DMNCaptainKromcrush"][1] = "대장 크롬크러쉬";
    AtlasLoot_TableNames["DMNKingGordok"][1] = "왕 고르독";
    AtlasLoot_TableNames["DMNChoRush"][1] = "정찰병 초루쉬";
    AtlasLoot_TableNames["DMNTRIBUTERUN"][1] = "공물함";
    --Dire Maul West
    AtlasLoot_TableNames["DMWTendrisWarpwood"][1] = "굽이나무 텐드리스";
    AtlasLoot_TableNames["DMWIllyannaRavenoak"][1] = "일샨나 레이븐오크";
    AtlasLoot_TableNames["DMWMagisterKalendris"][1] = "마법사 칼렌드리스";
    AtlasLoot_TableNames["DMWTsuzee"][1] = "츄지";
    AtlasLoot_TableNames["DMWImmolthar"][1] = "이몰타르";
    AtlasLoot_TableNames["DMWHelnurath"][1] = "군주 헬누라스";
    AtlasLoot_TableNames["DMWPrinceTortheldrin"][1] = "왕자 토르텔드린";
    AtlasLoot_TableNames["DMWTrash"][1] = "일반몹 (혈투의 전장 - 서쪽)";
    --Gnomeregan
    AtlasLoot_TableNames["GnViscousFallout"][1] = "상사성 폐기물";
    AtlasLoot_TableNames["GnGrubbis"][1] = "그루비스";
    AtlasLoot_TableNames["GnElectrocutioner6000"][1] = "삐까뻔쩍세척기 6000";
    AtlasLoot_TableNames["GnMekgineerThermaplugg"][1] = "멕기니어 텔마플러그";
    AtlasLoot_TableNames["GnDIAmbassador"][1] = "검은무쇠단 사절";
    AtlasLoot_TableNames["GnCrowdPummeler960"][1] = "고철압축기 9-60";
    AtlasLoot_TableNames["GnTrash"][1] = "일반몹 (놈리건)";
    --Gruul's Lair
    AtlasLoot_TableNames["GruulsLairHighKingMaulgar"][1] = "왕중왕 마울가르";
    AtlasLoot_TableNames["GruulGruul"][1] = "용 학살자 그룰";
    --HC: Blood Furnace
    AtlasLoot_TableNames["HCFurnaceMaker"][1] = "재앙의 창조자";
    AtlasLoot_TableNames["HCFurnaceMakerHEROIC"][1] = "재앙의 창조자 (영웅)";
    AtlasLoot_TableNames["HCFurnaceBroggok"][1] = "브로고크";
    AtlasLoot_TableNames["HCFurnaceBroggokHEROIC"][1] = "브로고크 (영웅)";
    AtlasLoot_TableNames["HCFurnaceBreaker"][1] = "파괴자 켈리단";
    AtlasLoot_TableNames["HCFurnaceBreakerHEROIC"][1] = "파괴자 켈리단 (영웅)";
    --HC: Magtheridon's Lair
    AtlasLoot_TableNames["HCMagtheridon"][1] = "마그테리돈";
    --HC: Ramparts
    AtlasLoot_TableNames["HCRampWatchkeeper"][1] = "감시자 가르골마르";
    AtlasLoot_TableNames["HCRampWatchkeeperHEROIC"][1] = "감시자 가르골마르 (영웅)";
    AtlasLoot_TableNames["HCRampOmor"][1] = "무적의 오모르";
    AtlasLoot_TableNames["HCRampOmorHEROIC"][1] = "무적의 오모르 (영웅)";
    AtlasLoot_TableNames["HCRampVazruden"][1] = "바즈루덴";
    AtlasLoot_TableNames["HCRampNazan"][1] = "나잔";
    AtlasLoot_TableNames["HCRampFelIronChest"][1] = "Reinforced Fel Iron Chest";
    AtlasLoot_TableNames["HCRampFelIronChestHEROIC"][1] = "Reinforced Fel Iron Chest (영웅)";
    --HC: Shattered Halls
    AtlasLoot_TableNames["HCHallsNethekurse"][1] = "대흑마법사 네더쿠르스";
    AtlasLoot_TableNames["HCHallsNethekurseHEROIC"][1] = "대흑마법사 네더쿠르스 (영웅)";
    AtlasLoot_TableNames["HCHallsPorung"][1] = "혈투사 포룽";
    AtlasLoot_TableNames["HCHallsOmrogg"][1] = "돌격대장 오므로그";
    AtlasLoot_TableNames["HCHallsOmroggHEROIC"][1] = "돌격대장 오므로그 (영웅)";
    AtlasLoot_TableNames["HCHallsKargath"][1] = "대족장 카르가스 블레이드피스트";
    AtlasLoot_TableNames["HCHallsKargathHEROIC"][1] = "대족장 카르가스 블레이드피스트 (영웅)";
    AtlasLoot_TableNames["HCHallsTrash"][1] = "일반몹 (으스러진 손의 전당)";
    --Karazhan
    AtlasLoot_TableNames["KaraAttumen"][1] = "사냥꾼 어튜멘";
    AtlasLoot_TableNames["KaraNamed"][1] = "렌덤 동물 보스";
    AtlasLoot_TableNames["KaraMoroes"][1] = "모로스";
    AtlasLoot_TableNames["KaraMaiden"][1] = "고결의 여신";
    AtlasLoot_TableNames["KaraOperaEvent"][1] = "오페라 극장 이벤트";
    AtlasLoot_TableNames["KaraCurator"][1] = "전시 관리인";
    AtlasLoot_TableNames["KaraIllhoof"][1] = "테레스티안 일후프";
    AtlasLoot_TableNames["KaraAran"][1] = "아란의 망령";
    AtlasLoot_TableNames["KaraNetherspite"][1] = "황천의 원령";
    AtlasLoot_TableNames["KaraNightbane"][1] = "파멸의 어둠";
    AtlasLoot_TableNames["KaraChess"][1] = "체스 이벤트";
    AtlasLoot_TableNames["KaraPrince"][1] = "공작 말체자르";
    AtlasLoot_TableNames["KaraTrash"][1] = "일반몹 (카라잔)";
    --Maraudon
    AtlasLoot_TableNames["MaraNoxxion"][1] = "녹시온";
    AtlasLoot_TableNames["MaraRazorlash"][1] = "칼날채찍";
    AtlasLoot_TableNames["MaraLordVyletongue"][1] = "군주 바일텅";
    AtlasLoot_TableNames["MaraMeshlok"][1] = "정원사 메슬로크";
    AtlasLoot_TableNames["MaraCelebras"][1] = "저주받은 셀레브라스";
    AtlasLoot_TableNames["MaraLandslide"][1] = "산사태";
    AtlasLoot_TableNames["MaraTinkererGizlock"][1] = "땜장이 기즐록";
    AtlasLoot_TableNames["MaraRotgrip"][1] = "썩은 아귀";
    AtlasLoot_TableNames["MaraPrincessTheradras"][1] = "공주 테라드라스";
    --Molten Core
    AtlasLoot_TableNames["MCLucifron"][1] = "루시프론";
    AtlasLoot_TableNames["MCMagmadar"][1] = "마그마다르";
    AtlasLoot_TableNames["MCGehennas"][1] = "게헨나스";
    AtlasLoot_TableNames["MCGarr"][1] = "가르";
    AtlasLoot_TableNames["MCShazzrah"][1] = "샤즈라";
    AtlasLoot_TableNames["MCGeddon"][1] = "남작 게돈";
    AtlasLoot_TableNames["MCGolemagg"][1] = "초열의 골레마그";
    AtlasLoot_TableNames["MCSulfuron"][1] = "설퍼론 사자";
    AtlasLoot_TableNames["MCMajordomo"][1] = "청지기 이그젝큐투스";
    AtlasLoot_TableNames["MCRagnaros"][1] = "라그나로스";
    AtlasLoot_TableNames["MCTrashMobs"][1] = "일반몹";
    AtlasLoot_TableNames["MCRANDOMBOSSDROPPS"][1] = "렌덤 보스 루팅";
    --Naxxramas
    AtlasLoot_TableNames["NAXPatchwerk"][1] = "패치워크";
    AtlasLoot_TableNames["NAXGrobbulus"][1] = "그라불루스";
    AtlasLoot_TableNames["NAXGluth"][1] = "글루스";
    AtlasLoot_TableNames["NAXThaddius"][1] = "타디우스";
    AtlasLoot_TableNames["NAXAnubRekhan"][1] = "아눕레칸";
    AtlasLoot_TableNames["NAXGrandWidowFaerlina"][1] = "여군주 펠리나";
    AtlasLoot_TableNames["NAXMaexxna"][1] = "맥스나";
    AtlasLoot_TableNames["NAXInstructorRazuvious"][1] = "훈련교관 라주비어스";
    AtlasLoot_TableNames["NAXGothikderHarvester"][1] = "영혼의 착취자 고딕";
    AtlasLoot_TableNames["NAXTheFourHorsemen"][1] = "4명의 기사단";
    AtlasLoot_TableNames["NAXNothderPlaguebringer"][1] = "역병술사 노스";
    AtlasLoot_TableNames["NAXHeiganderUnclean"][1] = "부정의 헤이건";
    AtlasLoot_TableNames["NAXLoatheb"][1] = "로데브";
    AtlasLoot_TableNames["NAXSapphiron"][1] = "사피론";
    AtlasLoot_TableNames["NAXKelThuzard"][1] = "켈투자드";
    AtlasLoot_TableNames["NAXTrash"][1] = "일반몹 (낙스라마스)";
    --Onyxia's Lair
    AtlasLoot_TableNames["Onyxia"][1] = "오닉시아";
    --Ragefire Chasm
    AtlasLoot_TableNames["RFCTaragaman"][1] = "용망의 타라가만";
    AtlasLoot_TableNames["RFCJergosh"][1] = "기원사 제로쉬";
    --Razorfen Downs
    AtlasLoot_TableNames["RFDTutenkash"][1] = "거미왕 투텐카쉬";
    AtlasLoot_TableNames["RFDHenryStern"][1] = "헨리 스턴";
    AtlasLoot_TableNames["RFDMordreshFireEye"][1] = "불꽃눈 모드레쉬";
    AtlasLoot_TableNames["RFDGlutton"][1] = "개걸먹보";
    AtlasLoot_TableNames["RFDRagglesnout"][1] = "너덜주둥이";
    AtlasLoot_TableNames["RFDAmnennar"][1] = "흑한의 암네나르";
    AtlasLoot_TableNames["RFDPlaguemaw"][1] = "썩어가는 역병아귀";
    AtlasLoot_TableNames["RFDTrash"][1] = "일반몹 (가시덩쿨 구릉)";
    --Razorfen Kraul
    AtlasLoot_TableNames["RFKThorncurse"][1] = "저주의가시 아겜";
    AtlasLoot_TableNames["RFKDeathSpeakerJargba"][1] = "죽음의 예언자 잘그바";
    AtlasLoot_TableNames["RFKOverlordRamtusk"][1] = "대군주 램터스크";
    AtlasLoot_TableNames["RFKAgathelos"][1] = "흉포한 아가테로스";
    AtlasLoot_TableNames["RFKBlindHunter"][1] = "장님 사냥꾼";
    AtlasLoot_TableNames["RFKCharlgaRazorflank"][1] = "서슬깃 차를가";
    AtlasLoot_TableNames["RFKEarthcallerHalmgar"][1] = "대지술사 함가르";
    AtlasLoot_TableNames["RFKTrash"][1] = "일반몹 (가시덩쿨 우리)";
    --The Ruins of Ahn'Qiraj
    AtlasLoot_TableNames["AQ20Kurinnaxx"][1] = "쿠린낙스";
    AtlasLoot_TableNames["AQ20Andorov"][1] = "사령관 안도로브";
    AtlasLoot_TableNames["AQ20CAPTIAN"][1] = "라작스의 장군들";
    AtlasLoot_TableNames["AQ20Rajaxx"][1] = "장군 라작스";
    AtlasLoot_TableNames["AQ20Moam"][1] = "모암";
    AtlasLoot_TableNames["AQ20Buru"][1] = "먹보 부루";
    AtlasLoot_TableNames["AQ20Ayamiss"][1] = "사냥꾼 아야미스";
    AtlasLoot_TableNames["AQ20Ossirian"][1] = "무적의 오시리안";
    AtlasLoot_TableNames["AQ20ClassBooks"][1] =  "직업 책";
    AtlasLoot_TableNames["AQEnchants"][1] = "안퀴라즈 마법부여";
    --Scarlet Monestery - Armory
    AtlasLoot_TableNames["SMHerod"][1] = "헤로드";
    AtlasLoot_TableNames["SMTrash"][1] = "일반몹 (붉은십자군)";
    --Scarlet Monestery - Cathedral
    AtlasLoot_TableNames["SMFairbanks"][1] = "종교재판관 패어뱅크스";
    AtlasLoot_TableNames["SMMograine"][1] = "붉은십자군 사령관 모그레인";
    AtlasLoot_TableNames["SMWhitemane"][1] = "종교재판관 화이트메인";
    --Scarlet Monestery - Graveyard
    AtlasLoot_TableNames["SMVishas"][1] = "심문관 비샤스";
    AtlasLoot_TableNames["SMIronspine"][1] = "무쇠해골";
    AtlasLoot_TableNames["SMAzshir"][1] = "잠들지 않는 아즈쉬르";
    AtlasLoot_TableNames["SMFallenChampion"][1] = "타락한 용사";
    AtlasLoot_TableNames["SMBloodmageThalnos"][1] = "혈법사 탈노스";
    --Scarlet Monestery - Library
    AtlasLoot_TableNames["SMHoundmasterLoksey"][1] = "사냥개조련사 록시";
    AtlasLoot_TableNames["SMDoan"][1] = "신비술사 도안";
    --Scholomance
    AtlasLoot_TableNames["SCHOLOKirtonostheHerald"][1] = "사자 키르토노스";
    AtlasLoot_TableNames["SCHOLOJandiceBarov"][1] = "잔다이스 바로브";
    AtlasLoot_TableNames["SCHOLORattlegore"][1] = "들창어금니";
    AtlasLoot_TableNames["SCHOLODeathKnight"][1] = "죽음의 기사 다크리버";
    AtlasLoot_TableNames["SCHOLOMarduk"][1] = "마르두크 블랙풀";
    AtlasLoot_TableNames["SCHOLOVectus"][1] = "벡투스";
    AtlasLoot_TableNames["SCHOLORasFrostwhisper"][1] = "라스 프로스트위스퍼";
    AtlasLoot_TableNames["SCHOLOKormok"][1] = "코르모크";
    AtlasLoot_TableNames["SCHOLOInstructorMalicia"][1] = "조교 말리시아";
    AtlasLoot_TableNames["SCHOLODoctorTheolenKrastinov"][1] = "학자 테올렌 크리스티노브";
    AtlasLoot_TableNames["SCHOLOLorekeeperPolkelt"][1] = "현자 폴켄트";
    AtlasLoot_TableNames["SCHOLOTheRavenian"][1] = "라베니안";
    AtlasLoot_TableNames["SCHOLOLordAlexeiBarov"][1] = "군주 알렉세이 바로브";
    AtlasLoot_TableNames["SCHOLOLadyIlluciaBarov"][1] = "여군주 일루시아 바로브";
    AtlasLoot_TableNames["SCHOLODarkmasterGandling"][1] = "암흑스승 간들링";
    AtlasLoot_TableNames["SCHOLOTrash"][1] = "일반몹 (스칼로맨스)";
    --Shadowfang Keep
    AtlasLoot_TableNames["BSFRazorclawtheButcher"][1] = "도살자 칼날발톱";
    AtlasLoot_TableNames["BSFSilverlaine"][1] = "남작 실버레인";
    AtlasLoot_TableNames["BSFSpringvale"][1] = "사령관 스프링베일";
    AtlasLoot_TableNames["BSFOdotheBlindwatcher"][1] = "눈먼 감시자 오도";
    AtlasLoot_TableNames["BSFFenrustheDevourer"][1] = "파멸의 펜루스";
    AtlasLoot_TableNames["BSFWolfMasterNandos"][1] = "늑대왕 난도스";
    AtlasLoot_TableNames["BSFArchmageArugal"][1] = "대마법사 아루갈";
    AtlasLoot_TableNames["BSFTrash"][1] = "일반몹 (그림자송곳니 성채)";
    --The Stockade
    AtlasLoot_TableNames["SWStTargor"][1] = "흉악범 타고르";
    AtlasLoot_TableNames["SWStKamDeepfury"][1] = "캄 딥퓨리";
    AtlasLoot_TableNames["SWStBazilThredd"][1] = "바질 스레드";
    AtlasLoot_TableNames["SWStDextrenWard"][1] = "덱스트렌 워드";
    AtlasLoot_TableNames["SWStBruegalIronknuckle"][1] = "브루갈 아이언너클";
    --Stratholme
    AtlasLoot_TableNames["STRATSkull"][1] = "스컬";
    AtlasLoot_TableNames["STRATStratholmeCourier"][1] = "우체통 열쇠";
    AtlasLoot_TableNames["STRATFrasSiabi"][1] = "프라스 샤비";
    AtlasLoot_TableNames["STRATHearthsingerForresten"][1] = "하스싱어 포레스턴";
    AtlasLoot_TableNames["STRATTheUnforgiven"][1] = "용서받지 못한 자";
    AtlasLoot_TableNames["STRATTimmytheCruel"][1] = "잔혹한 티미";
    AtlasLoot_TableNames["STRATCannonMasterWilley"][1] = "포병대장 윌리";
    AtlasLoot_TableNames["STRATArchivistGalford"][1] = "기록관 갈포드";
    AtlasLoot_TableNames["STRATBalnazzar"][1] = "발나자르";
    AtlasLoot_TableNames["STRATSothosJarien"][1] = "소도스, 자리엔";
    AtlasLoot_TableNames["STRATStonespine"][1] = "뾰족바위";
    AtlasLoot_TableNames["STRATBaronessAnastari"][1] = "남작부인 아나스타리";
    AtlasLoot_TableNames["STRATNerubenkan"][1] = "네룹엔칸";
    AtlasLoot_TableNames["STRATMalekithePallid"][1] = "냉혈한 말레키";
    AtlasLoot_TableNames["STRATMagistrateBarthilas"][1] = "집정관 바실라스";
    AtlasLoot_TableNames["STRATRamsteintheGorger"][1] = "먹보 람스타인";
    AtlasLoot_TableNames["STRATBaronRivendare"][1] = "남작 리븐데어";
    AtlasLoot_TableNames["STRATTrash"][1] = "일반몹 (스트라솔름)";
    --Sunken Temple
    AtlasLoot_TableNames["STTrollMinibosses"][1] = "결계 수호자";
    AtlasLoot_TableNames["STAtalalarion"][1] = "아탈알라리온";
    AtlasLoot_TableNames["STDreamscythe"][1] = "드림사이드";
    AtlasLoot_TableNames["STWeaver"][1] = "위버";
    AtlasLoot_TableNames["STAvatarofHakkar"][1] = "학카르의 화신";
    AtlasLoot_TableNames["STJammalan"][1] = "예언자 잠말란";
    AtlasLoot_TableNames["STOgom"][1] = "비운의 오그옴";
    AtlasLoot_TableNames["STMorphaz"][1] = "몰파즈";
    AtlasLoot_TableNames["STHazzas"][1] = "하자스";
    AtlasLoot_TableNames["STEranikus"][1] = "에라니쿠스의 사령";
    AtlasLoot_TableNames["STTrash"][1] = "일반몹 (아탈학카르 신전)";
    --Sunwell Isle: Magister's Terrace
    AtlasLoot_TableNames["SMTFireheart"][1] = "Selin Fireheart";
    AtlasLoot_TableNames["SMTFireheartHEROIC"][1] = "Selin Fireheart (Heroic)";
	AtlasLoot_TableNames["SMTVexallus"][1] = "Vexallus";
    AtlasLoot_TableNames["SMTVexallusHEROIC"][1] = "Vexallus (Heroic)";
    AtlasLoot_TableNames["SMTDelrissa"][1] = "Priestess Delrissa";
    AtlasLoot_TableNames["SMTDelrissaHEROIC"][1] = "Priestess Delrissa (Heroic)";
    AtlasLoot_TableNames["SMTKaelthas"][1] = "Kael'thas Sunstrider";
    AtlasLoot_TableNames["SMTKaelthasHEROIC"][1] = "Kael'thas Sunstrider (Heroic)";
    AtlasLoot_TableNames["SMTTrash"][1] = "Trash Mobs (Magister's Terrace)";
  --Sunwell Plateau
    AtlasLoot_TableNames["SPKalecgos"][1] = "Kalecgos";
    AtlasLoot_TableNames["SPBrutallus"][1] = "Brutallus";
    AtlasLoot_TableNames["SPFelmyst"][1] = "Felmyst";
    AtlasLoot_TableNames["SPEredarTwins"][1] = "Eredar Twins";
    AtlasLoot_TableNames["SPMuru"][1] = "M'uru";
    AtlasLoot_TableNames["SPKiljaeden"][1] = "Kil'jaden";
    AtlasLoot_TableNames["SPTrash"][1] = "Trash Mobs (Sunwell Plateau)";
    --Temple of Ahn'Qiraj
    AtlasLoot_TableNames["AQ40Skeram"][1] = "예언자 스케람";
    AtlasLoot_TableNames["AQ40Vem"][1] = "크리/야우즈/벰";
    AtlasLoot_TableNames["AQ40Sartura"][1] = "전투감시병 살투라";
    AtlasLoot_TableNames["AQ40Fankriss"][1] = "불굴의 판크리스";
    AtlasLoot_TableNames["AQ40Viscidus"][1] = "비시디우스";
    AtlasLoot_TableNames["AQ40Huhuran"][1] = "공주 후후란";
    AtlasLoot_TableNames["AQ40Emperors"][1] = "쌍둥이 황제";
    AtlasLoot_TableNames["AQ40Ouro"][1] = "아우로";
    AtlasLoot_TableNames["AQ40CThun"][1] = "쑨의 눈";
    AtlasLoot_TableNames["AQ40Trash1"][1] = "일반몹 (안퀴라즈 사원)";
    AtlasLoot_TableNames["AQOpening"][1] = "안퀴라즈 오프닝 연퀘";
    --TK: The Arcatraz
    AtlasLoot_TableNames["TKArcUnbound"][1] = "속박이 풀린 제레케스";
    AtlasLoot_TableNames["TKArcUnboundHEROIC"][1] = "속박이 풀린 제레케스 (영웅)";
    AtlasLoot_TableNames["TKArcScryer"][1] = "격노의 점술사 소코드라테스";
    AtlasLoot_TableNames["TKArcScryerHEROIC"][1] = "격노의 점술사 소코드라테스 (영웅)";
    AtlasLoot_TableNames["TKArcDalliah"][1] = "파멸의 예언자 달리아";
    AtlasLoot_TableNames["TKArcDalliahHEROIC"][1] = "파멸의 예언자 달리아 (영웅)";
    AtlasLoot_TableNames["TKArcHarbinger"][1] = "선구자 스키리스";
    AtlasLoot_TableNames["TKArcHarbingerHEROIC"][1] = "선구자 스키리스 (영웅)";
    AtlasLoot_TableNames["TKArcTrash"][1] = "일반몹 (알카트라즈)";
    --TK: The Botanica
    AtlasLoot_TableNames["TKBotSarannis"][1] = "지휘관 새래니스";
    AtlasLoot_TableNames["TKBotSarannisHEROIC"][1] = "지휘관 새래니스 (영웅)";
    AtlasLoot_TableNames["TKBotFreywinn"][1] = "고위 식물학자 프레이윈느";
    AtlasLoot_TableNames["TKBotFreywinnHEROIC"][1] = "고위 식물학자 프레이윈 (영웅)";
    AtlasLoot_TableNames["TKBotThorngrin"][1] = "감시인 쏜그린";
    AtlasLoot_TableNames["TKBotThorngrinHEROIC"][1] = "감시인 쏜그 (영웅)";
    AtlasLoot_TableNames["TKBotLaj"][1] = "라즈";
    AtlasLoot_TableNames["TKBotLajHEROIC"][1] = "라즈 (영웅)";
    AtlasLoot_TableNames["TKBotSplinter"][1] = "차원의 분리자";
    AtlasLoot_TableNames["TKBotSplinterHEROIC"][1] = "차원의 분리자 (영웅)";
    AtlasLoot_TableNames["TKBotTrash"][1] = "일반몹 (신록의 정원)";
    --TK: The Eye
    AtlasLoot_TableNames["TKEyeAlar"][1] = "불사조의 신 알아르";
    AtlasLoot_TableNames["TKEyeVoidReaver"][1] = "공허의 절단기";
    AtlasLoot_TableNames["TKEyeSolarian"][1] = "고위 황천술사 솔라리안";
    AtlasLoot_TableNames["TKEyeKaelthas"][1] = "캘타스 선스트라이더";
    AtlasLoot_TableNames["TKEyeTrash"][1] = "일반몹 (푹풍의 요새)";
    --TK: The Mechanar
    AtlasLoot_TableNames["TKMechGyro"][1] = "문지기 회전톱날";
    AtlasLoot_TableNames["TKMechIron"][1] = "문지기 무쇠주먹";
    AtlasLoot_TableNames["TKMechCacheoftheLegion"][1] = "군단 저장고";
    AtlasLoot_TableNames["TKMechCapacitus"][1] = "기계군주 캐퍼시투스";
    AtlasLoot_TableNames["TKMechCapacitusHEROIC"][1] = "기계군주 캐퍼시투스 (영웅)";
    AtlasLoot_TableNames["TKMechSepethrea"][1] = "황천술사 세페스레아";
    AtlasLoot_TableNames["TKMechSepethreaHEROIC"][1] = "황천술사 세페스레아 (영웅)";
    AtlasLoot_TableNames["TKMechCalc"][1] = "철두철미한 파탈리온";
    AtlasLoot_TableNames["TKMechCalcHEROIC"][1] = "철두철미한 파탈리온 (영웅)";
    AtlasLoot_TableNames["TKMechTrash"][1] = "일반몹 (메카나르)";
    --Uldaman
    AtlasLoot_TableNames["UldRevelosh"][1] = "벨로그";
    AtlasLoot_TableNames["UldIronaya"][1] = "아이로나야";
    AtlasLoot_TableNames["UldAncientStoneKeeper"][1] = "고대 바위 문지기";
    AtlasLoot_TableNames["UldGalgannFirehammer"][1] = "갈간 파이어해머";
    AtlasLoot_TableNames["UldGrimlok"][1] = "그림로크";
    AtlasLoot_TableNames["UldArchaedas"][1] = "아카에다스";
    AtlasLoot_TableNames["UldTrash"][1] = "일반몹 (울다만)";
    --Wailing Caverns
    AtlasLoot_TableNames["WCLordCobrahn"][1] = "군주 코브란";
    AtlasLoot_TableNames["WCLadyAnacondra"][1] = "여군주 아나콘드라";
    AtlasLoot_TableNames["WCKresh"][1] = "크레쉬";
    AtlasLoot_TableNames["WCLordPythas"][1] = "군주 피타스";
    AtlasLoot_TableNames["WCSkum"][1] = "스쿰";
    AtlasLoot_TableNames["WCLordSerpentis"][1] = "군주 서펜티스";
    AtlasLoot_TableNames["WCVerdan"][1] = "영생의 베르단";
    AtlasLoot_TableNames["WCMutanus"][1] = "걸신들린 무타누스";
    AtlasLoot_TableNames["WCDeviateFaerieDragon"][1] = "돌연변이 요정용";
    --Zul'Farrak
    AtlasLoot_TableNames["ZFAntusul"][1] = "아투술";
    AtlasLoot_TableNames["ZFThekatheMartyr"] = { "Theka the Martyr", "AtlasLootItems" };
    AtlasLoot_TableNames["ZFWitchDoctorZumrah"][1] = "순교자 줌라";
    AtlasLoot_TableNames["ZFNekrumGutchewer"] = { "Nekrum Gutchewer", "AtlasLootItems" };
    AtlasLoot_TableNames["ZFSezzziz"][1] = "어둠의 사제 세즈시즈";
    AtlasLoot_TableNames["ZFDustwraith"][1] = "더스트레이스";
    AtlasLoot_TableNames["ZFSergeantBly"] = { "Sergeant Bly", "AtlasLootItems" };
    AtlasLoot_TableNames["ZFSandfury"][1] = "성난모래부족 사형집행인";
    AtlasLoot_TableNames["ZFHydromancerVelratha"] = { "Hydromancer Velratha", "AtlasLootItems" };
    AtlasLoot_TableNames["ZFGahzrilla"][1] = "가즈릴라";
    AtlasLoot_TableNames["ZFChiefUkorzSandscalp"][1] = "족장 우코르즈 샌드스칼프";
    AtlasLoot_TableNames["ZFZerillis"][1] = "젤리리스";
    AtlasLoot_TableNames["ZFTrash"][1] = "일반몹 (줄파락)";
    --Zul'Gurub
    AtlasLoot_TableNames["ZGJeklik"][1] = "대여사제 제클릭";
    AtlasLoot_TableNames["ZGVenoxis"][1] = "대사제 베녹시스";
    AtlasLoot_TableNames["ZGMarli"][1] = "대여사제 말리";
    AtlasLoot_TableNames["ZGMandokir"][1] = "혈군주 만도키르";
    AtlasLoot_TableNames["ZGGrilek"][1] = "철혈의 그리렉";
    AtlasLoot_TableNames["ZGHazzarah"][1] = "몽술사 하자라";
    AtlasLoot_TableNames["ZGRenataki"][1] = "천검의 레나타키";
    AtlasLoot_TableNames["ZGWushoolay"][1] = "폭풍마녀 우슐레이";
    AtlasLoot_TableNames["ZGGahzranka"][1] = "가즈란카";
    AtlasLoot_TableNames["ZGThekal"][1] = "대사제 데칼";
    AtlasLoot_TableNames["ZGArlokk"][1] = "대여사제 알로크";
    AtlasLoot_TableNames["ZGJindo"][1] = "주술사 진도";
    AtlasLoot_TableNames["ZGHakkar"][1] = "학카르";
    AtlasLoot_TableNames["ZGShared"][1] = "줄구룹 사제 드랍(공유)";
    AtlasLoot_TableNames["ZGTrash1"][1] = "일반몹 (줄구룹)";
    AtlasLoot_TableNames["ZGTrash2"][1] = "일반몹 (줄구룹)";
    AtlasLoot_TableNames["ZGEnchants"][1] = "줄구룹 마법부여";
    --Arena PvP Sets, Season 1
    AtlasLoot_TableNames["ArenaDruid"][1] = "드루이드 전장 세트";
    AtlasLoot_TableNames["ArenaHunter"][1] = "사냥꾼 전장 세트";
    AtlasLoot_TableNames["ArenaMage"][1] = "마법사 전장 세트";
    AtlasLoot_TableNames["ArenaPaladin"][1] = "성기사 전장 세트";
    AtlasLoot_TableNames["ArenaPriest"][1] = "사제 전장 세트";
    AtlasLoot_TableNames["ArenaRogue"][1] = "도적 전장 세트";
    AtlasLoot_TableNames["ArenaShaman"][1] = "주술사 전장 세트";
    AtlasLoot_TableNames["ArenaWarlock"][1] = "흑마법사 전장 세트";
    AtlasLoot_TableNames["ArenaWarrior"][1] = "전사 전장 세트";
    --Arena PvP Sets, Season 2
    AtlasLoot_TableNames["Arena2Druid"][1] = "드루이드 전장 세트";
    AtlasLoot_TableNames["Arena2Hunter"][1] = "사냥꾼 전장 세트";
    AtlasLoot_TableNames["Arena2Mage"][1] = "마법사 전장 세트";
    AtlasLoot_TableNames["Arena2Paladin"][1] = "성기사 전장 세트";
    AtlasLoot_TableNames["Arena2Priest"][1] = "사제 전장 세트";
    AtlasLoot_TableNames["Arena2Rogue"][1] = "도적 전장 세트";
    AtlasLoot_TableNames["Arena2Shaman"][1] = "주술사 전장 세트";
    AtlasLoot_TableNames["Arena2Warlock"][1] = "흑마법사 전장 세트";
    AtlasLoot_TableNames["Arena2Warrior"][1] = "전사 전장 세트";
   --Arena PvP Sets, Season 3
    AtlasLoot_TableNames["Arena3Druid"][1] = "드루이드 전장 세트";
    AtlasLoot_TableNames["Arena3Hunter"][1] = "사냥꾼 전장 세트";
    AtlasLoot_TableNames["Arena3Mage"][1] = "마법사 전장 세트";
    AtlasLoot_TableNames["Arena3Paladin"][1] = "성기사 전장 세트";
    AtlasLoot_TableNames["Arena3Priest"][1] = "사제 전장 세트";
    AtlasLoot_TableNames["Arena3Rogue"][1] = "도적 전장 세트";
    AtlasLoot_TableNames["Arena3Shaman"][1] = "주술사 전장 세트";
    AtlasLoot_TableNames["Arena3Warlock"][1] = "흑마법사 전장 세트";
    AtlasLoot_TableNames["Arena3Warrior"][1] = "전사 전장 세트";
   --Arena PvP Sets, Season 4
    AtlasLoot_TableNames["Arena4Druid"][1] = "드루이드 전장 세트";
    AtlasLoot_TableNames["Arena4Hunter"][1] = "사냥꾼 전장 세트";
    AtlasLoot_TableNames["Arena4Mage"][1] = "마법사 전장 세트";
    AtlasLoot_TableNames["Arena4Paladin"][1] = "성기사 전장 세트";
    AtlasLoot_TableNames["Arena4Priest"][1] = "사제 전장 세트";
    AtlasLoot_TableNames["Arena4Rogue"][1] = "도적 전장 세트";
    AtlasLoot_TableNames["Arena4Shaman"][1] = "주술사 전장 세트";
    AtlasLoot_TableNames["Arena4Warlock"][1] = "흑마법사 전장 세트";
    AtlasLoot_TableNames["Arena4Warrior"][1] = "전사 전장 세트";
    --Level 60 PvP Sets
    AtlasLoot_TableNames["PVPDruid"][1] = "드루이드 PvP 세트 (Lvl 60)";
    AtlasLoot_TableNames["PVPHunter"][1] = "사냥꾼 PvP 세트 (Lvl 60)";
    AtlasLoot_TableNames["PVPMage"][1] = "마법사 PvP 세트 (Lvl 60)";
    AtlasLoot_TableNames["PVPPaladin"][1] = "성기사 PvP 세트 (Lvl 60)";
    AtlasLoot_TableNames["PVPPriest"][1] = "사제 PvP 세트 (Lvl 60)";
    AtlasLoot_TableNames["PVPRogue"][1] = "도적 PvP 세트 (Lvl 60)";
    AtlasLoot_TableNames["PVPShaman"][1] = "주술사 PvP 세트 (Lvl 60)";
    AtlasLoot_TableNames["PVPWarlock"][1] = "흑마법사 PvP 세트 (Lvl 60)";
    AtlasLoot_TableNames["PVPWarrior"][1] = "전사 PvP 세트 (Lvl 60)";
    --Level 70 PvP Sets
    AtlasLoot_TableNames["PVP70Druid1"][1] = "드루이드 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Druid2"][1] = "드루이드 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Hunter"][1] = "사냥꾼 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Mage"][1] = "마법사 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Paladin1"][1] = "성기사 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Paladin2"][1] = "성기사 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Priest"][1] = "사제 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Rogue"][1] = "도적 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Shaman1"][1] = "주술사 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Shaman2"][1] = "주술사 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Warlock"][1] = "흑마법사 PvP 세트 (Lvl 70)";
    AtlasLoot_TableNames["PVP70Warrior"][1] = "전사 PvP 세트 (Lvl 70)";
    --안퀴라즈 사원 세트
    AtlasLoot_TableNames["AQ40Druid"][1] = "드루이드 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Hunter"][1] = "사냥꾼 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Mage"][1] = "마법사 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Paladin"][1] = "성기사 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Priest"][1] = "사제 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Rogue"][1] = "도적 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Shaman"][1] = "주술사 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Warlock"][1] = "흑마법사 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Warrior"][1] = "전사 안퀴라즈 사원 세트";
    --안퀴라즈 사원 세트
    AtlasLoot_TableNames["AQ40Druid"][1] = "드루이드 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Hunter"][1] = "사냥꾼 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Mage"][1] = "마법사 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Paladin"][1] = "성기사 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Priest"][1] = "사제 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Rogue"][1] = "도적 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Shaman"][1] = "주술사 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Warlock"][1] = "흑마법사 안퀴라즈 사원 세트";
    AtlasLoot_TableNames["AQ40Warrior"][1] = "전사 안퀴라즈 사원 세트";
    --Vanilla WoW Sets 세트
    AtlasLoot_TableNames["VWOWDeadmines"][1] = "데피아즈단";
    AtlasLoot_TableNames["VWOWWailingC"][1] = "독사의 은총";
    AtlasLoot_TableNames["VWOWScarletM"][1] = "붉은십자군";
    AtlasLoot_TableNames["VWOWBlackrockD"][1] = "검투사";
    AtlasLoot_TableNames["VWOWIronweave"][1] = "강철매듭 전투장비";
    AtlasLoot_TableNames["VWOWScholoCloth"][1] = "시체더미 의복";
    AtlasLoot_TableNames["VWOWScholoLeather"][1] = "시체 수의";
    AtlasLoot_TableNames["VWOWScholoMail"][1] = "피고리 제복";
    AtlasLoot_TableNames["VWOWScholoPlate"][1] = "죽음의 뼈갑옷";
    AtlasLoot_TableNames["VWOWStrat"][1] = "우체국장";
    AtlasLoot_TableNames["VWOWScourgeInvasion"][1] = "스컬지 침공";
    AtlasLoot_TableNames["VWOWShardOfGods"][1] = "신의 파편";
    AtlasLoot_TableNames["VWOWZGRings"][1] = "줄구룹 반지";
    AtlasLoot_TableNames["VWOWSpiritofEskhandar"][1] = "에스칸다르의 영혼";
    AtlasLoot_TableNames["VWOWHakkariBlades"][1] = "학카리 쌍검";
    AtlasLoot_TableNames["VWOWPrimalBlessing"][1] = "원시 축복";
    AtlasLoot_TableNames["VWOWDalRend"][1] = "달렌드의 무기";
    AtlasLoot_TableNames["VWOWSpiderKiss"][1] = "거미의 입마춤";
    --The Burning Crusade Sets 세트
    AtlasLoot_TableNames["TBCTwinStars"][1] = "쌍둥이 별";
    AtlasLoot_TableNames["TBCAzzinothBlades"][1] = "아지노스의 쌍날검";
    --Crafted 세트 - Blacksmithing
    AtlasLoot_TableNames["ImperialPlate"][1] = "황제의 갑옷";
    AtlasLoot_TableNames["TheDarksoul"][1] = "검은 영혼의 손아귀";
    AtlasLoot_TableNames["FelIronPlate"][1] = "지옥무쇠 판금 방어구";
    AtlasLoot_TableNames["AdamantiteB"][1] = "아다만다이트 전투장비";
    AtlasLoot_TableNames["FlameG"][1] = "화염의 수호";
    AtlasLoot_TableNames["EnchantedAdaman"][1] = "마력 깃든 아다만다이트 갑옷";
    AtlasLoot_TableNames["KhoriumWard"][1] = "코륨 방어구";
    AtlasLoot_TableNames["FaithFelsteel"][1] = "지옥강철 전투장비";
    AtlasLoot_TableNames["BurningRage"][1] = "불타는 분노";
    AtlasLoot_TableNames["BloodsoulEmbrace"][1] = "붉은영혼의 손아귀";
    AtlasLoot_TableNames["FelIronChain"][1] = "지옥무쇠 사슬 방어구";
    --Crafted 세트 - Tailoring
    AtlasLoot_TableNames["BloodvineG"][1] = "붉은덩굴 의복";
    AtlasLoot_TableNames["NeatherVest"][1] = "황천매듭 제복";
    AtlasLoot_TableNames["ImbuedNeather"][1] = "마력 깃든 황천매듭 제복";
    AtlasLoot_TableNames["ArcanoVest"][1] = "비전매듭 의복";
    AtlasLoot_TableNames["TheUnyielding"][1] = "불굴의 방어구";
    AtlasLoot_TableNames["WhitemendWis"][1] = "백마법의 지혜";
    AtlasLoot_TableNames["SpellstrikeInfu"][1] = "마법 강타의 마력";
    AtlasLoot_TableNames["BattlecastG"][1] = "전투시전술 의복";
    AtlasLoot_TableNames["SoulclothEm"][1] = "영혼매듭 예복";
    AtlasLoot_TableNames["PrimalMoon"][1] = "태초의 달빛매듭 의복";
    AtlasLoot_TableNames["ShadowEmbrace"][1] = "어둠의 은총";
    AtlasLoot_TableNames["SpellfireWrath"][1] = "마법불꽃의 격노";
    --Crafted Sets - Leatherworking
    AtlasLoot_TableNames["VolcanicArmor"][1] = "화산 갑옷";
    AtlasLoot_TableNames["IronfeatherArmor"][1] = "무쇠깃털 갑옷";
    AtlasLoot_TableNames["StormshroudArmor"][1] = "폭풍안개 갑옷";
    AtlasLoot_TableNames["DevilsaurArmor"][1] = "데빌사우루스 갑옷";
    AtlasLoot_TableNames["BloodTigerH"][1] = "붉은호랑이 방어구";
    AtlasLoot_TableNames["PrimalBatskin"][1] = "원시 박쥐가죽";
    AtlasLoot_TableNames["WildDraenishA"][1] = "야생의 드레나이 방어구";
    AtlasLoot_TableNames["ThickDraenicA"][1] = "두꺼운 드레나이 방어구";
    AtlasLoot_TableNames["FelSkin"][1] = "지옥 가죽 방어구";
    AtlasLoot_TableNames["SClefthoof"][1] = "갈래발굽의 힘";
    AtlasLoot_TableNames["GreenDragonM"][1] = "녹색용 쇠사슬 갑옷";
    AtlasLoot_TableNames["BlueDragonM"][1] = "푸른용 쇠사슬 갑옷";
    AtlasLoot_TableNames["BlackDragonM"][1] = "검은용 쇠사슬 갑옷";
    AtlasLoot_TableNames["ScaledDraenicA"][1] = "드레나이 미늘 갑옷";
    AtlasLoot_TableNames["FelscaleArmor"][1] = "지옥껍질 갑옷";
    AtlasLoot_TableNames["FelstalkerArmor"][1] = "지옥추적자 갑옷";
    AtlasLoot_TableNames["NetherFury"][1] = "황천의 격노";
    AtlasLoot_TableNames["PrimalIntent"][1] = "원소쐐기 갑옷";
    AtlasLoot_TableNames["WindhawkArmor"][1] = "바람매 갑옷";
    AtlasLoot_TableNames["NetherscaleArmor"][1] = "황천비늘 갑옷";
    AtlasLoot_TableNames["NetherstrikeArmor"][1] = "황천쐐기 갑옷";
    --ZG Sets
    AtlasLoot_TableNames["ZGDruid"][1] = "드루이드 줄구룹 세트";
    AtlasLoot_TableNames["ZGHunter"][1] = "사냥꾼 줄구룹 세트";
    AtlasLoot_TableNames["ZGMage"][1] = "마법사 줄구룹 세트";
    AtlasLoot_TableNames["ZGPaladin"][1] = "성기사 줄구룹 세트";
    AtlasLoot_TableNames["ZGPriest"][1] = "사제 줄구룹 세트";
    AtlasLoot_TableNames["ZGRogue"][1] = "도적 줄구룹 세트";
    AtlasLoot_TableNames["ZGShaman"][1] = "주술사 줄구룹 세트";
    AtlasLoot_TableNames["ZGWarlock"][1] = "흑마법사 줄구룹 세트";
    AtlasLoot_TableNames["ZGWarrior"][1] = "전사 줄구룹 세트";
    --던전 세트 1/2
    AtlasLoot_TableNames["T0Druid"][1] = "드루이드 던전 세트 1/2";
    AtlasLoot_TableNames["T0Hunter"][1] = "사냥꾼 던전 세트 1/2";
    AtlasLoot_TableNames["T0Mage"][1] = "마법사 던전 세트 1/2";
    AtlasLoot_TableNames["T0Paladin"][1] = "성기사 던전 세트 1/2";
    AtlasLoot_TableNames["T0Priest"][1] = "사제 던전 세트 1/2";
    AtlasLoot_TableNames["T0Rogue"][1] = "도적 던전 세트 1/2";
    AtlasLoot_TableNames["T0Shaman"][1] = "주술사 던전 세트 1/2";
    AtlasLoot_TableNames["T0Warlock"][1] = "흑마법사 던전 세트 1/2";
    AtlasLoot_TableNames["T0Warrior"][1] = "전사 던전 세트 1/2";
    --T3 Sets
    AtlasLoot_TableNames["T3Druid"][1] = "드루이드 T3 세트";
    AtlasLoot_TableNames["T3Hunter"][1] = "사냥꾼 T3 세트";
    AtlasLoot_TableNames["T3Mage"][1] = "마법사 T3 세트";
    AtlasLoot_TableNames["T3Paladin"][1] = "성기사 T3 세트";
    AtlasLoot_TableNames["T3Priest"][1] = "사제 T3 세트";
    AtlasLoot_TableNames["T3Rogue"][1] = "도적 T3 세트";
    AtlasLoot_TableNames["T3Shaman"][1] = "주술사 T3 세트";
    AtlasLoot_TableNames["T3Warlock"][1] = "흑마법사 T3 세트";
    AtlasLoot_TableNames["T3Warrior"][1] = "전사 T3 세트";
    --T4 Sets
    AtlasLoot_TableNames["T4Druid"][1] = "드루이드 T4 세트";
    AtlasLoot_TableNames["T4Hunter"][1] = "사냥꾼 T4 세트";
    AtlasLoot_TableNames["T4Mage"][1] = "마법사 T4 세트";
    AtlasLoot_TableNames["T4Paladin"][1] = "성기사 T4 세트";
    AtlasLoot_TableNames["T4Priest"][1] = "사제 T4 세트";
    AtlasLoot_TableNames["T4Rogue"][1] = "도적 T4 세트";
    AtlasLoot_TableNames["T4Shaman"][1] = "주술사 T4 세트";
    AtlasLoot_TableNames["T4Warlock"][1] = "흑마법사 T4 세트";
    AtlasLoot_TableNames["T4Warrior"][1] = "전사 T4 세트";
    --T5 Sets
    AtlasLoot_TableNames["T5Druid"][1] = "드루이드 T5 세트";
    AtlasLoot_TableNames["T5Hunter"][1] = "사냥꾼 T5 세트";
    AtlasLoot_TableNames["T5Mage"][1] = "마법사 T5 세트";
    AtlasLoot_TableNames["T5Paladin"][1] = "성기사 T5 세트";
    AtlasLoot_TableNames["T5Priest"][1] = "사제 T5 세트";
    AtlasLoot_TableNames["T5Rogue"][1] = "도적 T5 세트";
    AtlasLoot_TableNames["T5Shaman"][1] = "주술사 T5 세트";
    AtlasLoot_TableNames["T5Warlock"][1] = "흑마법사 T5 세트";
    AtlasLoot_TableNames["T5Warrior"][1] = "전사 T5 세트";
    --T6 Sets
    AtlasLoot_TableNames["T6Druid"][1] = "드루이드 T6 세트";
	AtlasLoot_TableNames["T6Druid2"][1] = "드루이드 T6 세트";
    AtlasLoot_TableNames["T6Hunter"][1] = "사냥꾼 T6 세트";
    AtlasLoot_TableNames["T6Mage"][1] = "마법사 T6 세트";
    AtlasLoot_TableNames["T6Paladin"][1] = "성기사 T6 세트";
	AtlasLoot_TableNames["T6Paladin2"][1] = "성기사 T6 세트";
    AtlasLoot_TableNames["T6Priest"][1] = "사제 T6 세트";
    AtlasLoot_TableNames["T6Rogue"][1] = "도적 T6 세트";
    AtlasLoot_TableNames["T6Shaman"][1] = "주술사 T6 세트";
	AtlasLoot_TableNames["T6Shaman2"][1] = "주술사 T6 세트";
    AtlasLoot_TableNames["T6Warlock"][1] = "흑마법사 T6 세트";
    AtlasLoot_TableNames["T6Warrior"][1] = "전사 T6 세트";
    --Misc Sets
    AtlasLoot_TableNames["Legendaries"][1] = "전설급 아이템";
    AtlasLoot_TableNames["RareMounts1"][1] = "Rare Mounts - Original WoW";
    AtlasLoot_TableNames["RareMounts2"][1] = "Rare Mounts - The Burning Crusade";
    AtlasLoot_TableNames["Tabards1"][1] = "겉옷";
    AtlasLoot_TableNames["Tabards2"][1] = "겉옷";
    AtlasLoot_TableNames["CraftedWeapons1"][1] = "제작된 영웅 무기";
    AtlasLoot_TableNames["CraftedWeapons2"][1] = "제작된 영웅 무기";
    --Azuregos
    AtlasLoot_TableNames["AAzuregos"][1] = "아주어고스";
    --Doom Lord Kazzak
    AtlasLoot_TableNames["DoomLordKazzak"][1] = "파멸의 군주 카자크";
    --Doomwalker
    AtlasLoot_TableNames["DDoomwalker"][1] = "파멸의 절단기";
    --Emeriss
    AtlasLoot_TableNames["DEmeriss"][1] = "에메리스";
    --Highlord Kruul
    AtlasLoot_TableNames["KKruul"][1] = "Highlord Kruul";
    --Lethon
    AtlasLoot_TableNames["DLethon"][1] = "레손";
    --Taerar
    AtlasLoot_TableNames["DTaerar"][1] = "타에라";
    --Ysondre
    AtlasLoot_TableNames["DYsondre"][1] = "이손드레";
    --Aldor
    AtlasLoot_TableNames["Aldor1"][1] = BabbleFaction["The Aldor"]..": Friendly/Honored";
    AtlasLoot_TableNames["Aldor2"][1] = BabbleFaction["The Aldor"]..": Revered/Exalted";
    --The Argent Dawn
    AtlasLoot_TableNames["Argent1"][1] = BabbleFaction["Argent Dawn"]..": Token Hand-ins";
    AtlasLoot_TableNames["Argent2"][1] = BabbleFaction["Argent Dawn"];
    --Ashtongue Deathsworn
    AtlasLoot_TableNames["Ashtongue1"][1] = BabbleFaction["Ashtongue Deathsworn"];
    AtlasLoot_TableNames["Ashtongue2"][1] = BabbleFaction["Ashtongue Deathsworn"];
    --The Bloodsail Buccaneers
    AtlasLoot_TableNames["Bloodsail1"][1] = BabbleFaction["Bloodsail Buccaneers"];
    --The Brood of Nozdormu
    AtlasLoot_TableNames["AQBroodRings"][1] = BabbleFaction["Brood of Nozdormu"];
    --The Cenarion Circle
    AtlasLoot_TableNames["Cenarion1"][1] = BabbleFaction["Cenarion Circle"]..": Friendly";
    AtlasLoot_TableNames["Cenarion2"][1] = BabbleFaction["Cenarion Circle"]..": Honored";
    AtlasLoot_TableNames["Cenarion3"][1] = BabbleFaction["Cenarion Circle"]..": Revered";
    AtlasLoot_TableNames["Cenarion4"][1] = BabbleFaction["Cenarion Circle"]..": Exalted";
    --The Cenarion Expedition
    AtlasLoot_TableNames["CExpedition1"][1] = BabbleFaction["Cenarion Expedition"]..": Friendly/Honored";
    AtlasLoot_TableNames["CExpedition2"][1] = BabbleFaction["Cenarion Expedition"]..": Revered/Exalted";
    --The Consortium
    AtlasLoot_TableNames["Consortium1"][1] = BabbleFaction["The Consortium"]..": Friendly/Honored";
    AtlasLoot_TableNames["Consortium2"][1] = BabbleFaction["The Consortium"]..": Revered/Exalted";
    --The Darkmoon Faire
    AtlasLoot_TableNames["Darkmoon1"][1] = BabbleFaction["Darkmoon Faire"];
    AtlasLoot_TableNames["Darkmoon2"][1] = "Darkmoon Faire - Trinkets";
    --The Frostwolf Clan
    AtlasLoot_TableNames["Frostwolf1"][1] = BabbleFaction["Frostwolf Clan"];
    --The Hydraxian Waterlords
    AtlasLoot_TableNames["WaterLords1"][1] = BabbleFaction["Hydraxian Waterlords"];
    --Honor Hold
    AtlasLoot_TableNames["HonorHold1"][1] = BabbleFaction["Honor Hold"]..": Friendly/Honored";
    AtlasLoot_TableNames["HonorHold2"][1] = BabbleFaction["Honor Hold"]..": Revered/Exalted";
    --The Keepers of Time
    AtlasLoot_TableNames["KeepersofTime1"][1] = BabbleFaction["Keepers of Time"];
    --The Kurenai
    AtlasLoot_TableNames["Kurenai1"][1] = BabbleFaction["Kurenai"];
    --Lower City
    AtlasLoot_TableNames["LowerCity1"][1] = BabbleFaction["Lower City"];
    --The Mag'har
    AtlasLoot_TableNames["Maghar1"][1] = BabbleFaction["The Mag'har"];
    --Netherwing
    AtlasLoot_TableNames["Netherwing1"][1] = BabbleFaction["Netherwing"];
    --Ogri'la
    AtlasLoot_TableNames["Ogrila1"][1] = BabbleFaction["Ogri'la"];
    --The Scale of the Sands
    AtlasLoot_TableNames["ScaleSands1"][1] = BabbleFaction["The Scale of the Sands"];
    AtlasLoot_TableNames["ScaleSands2"][1] = BabbleFaction["The Scale of the Sands"];
    --The Scryers
    AtlasLoot_TableNames["Scryer1"][1] = BabbleFaction["The Scryers"]..": Friendly/Honored";
    AtlasLoot_TableNames["Scryer2"][1] = BabbleFaction["The Scryers"]..": Revered/Exalted";
    --The Sha'tar
    AtlasLoot_TableNames["Shatar1"][1] = BabbleFaction["The Sha'tar"];
    --Sha'tari Skyguard
    AtlasLoot_TableNames["Skyguard1"][1] = BabbleFaction["Sha'tari Skyguard"];
    --The Sporeggar
    AtlasLoot_TableNames["Sporeggar1"][1] = BabbleFaction["Sporeggar"];
    --The Stormpike Guards
    AtlasLoot_TableNames["Stormpike1"][1] = BabbleFaction["Stormpike Guard"];
    --The Thorium Brotherhood
    AtlasLoot_TableNames["Thorium1"][1] = BabbleFaction["Thorium Brotherhood"]..": Friendly/Honored";
    AtlasLoot_TableNames["Thorium2"][1] = BabbleFaction["Thorium Brotherhood"]..": Revered/Exalted";
    --Thrallmar
    AtlasLoot_TableNames["Thrallmar1"][1] = BabbleFaction["Thrallmar"]..": Friendly/Honored";
    AtlasLoot_TableNames["Thrallmar2"][1] = BabbleFaction["Thrallmar"]..": Revered/Exalted";
    --Timbermaw Hold
    AtlasLoot_TableNames["Timbermaw"][1] = BabbleFaction["Timbermaw Hold"];
    --The Tranquillien
    AtlasLoot_TableNames["Tranquillien1"][1] = BabbleFaction["Tranquillien"];
    --The Violet Eye
    AtlasLoot_TableNames["VioletEye1"][1] = BabbleFaction["The Violet Eye"];
    --The Wintersaber Trainers
    AtlasLoot_TableNames["Wintersaber1"][1] = BabbleFaction["Wintersaber Trainers"];
    --The Zandalar Tribe
    AtlasLoot_TableNames["Zandalar1"][1] = BabbleFaction["Zandalar Tribe"]..": Friendly/Honored";
    AtlasLoot_TableNames["Zandalar2"][1] = BabbleFaction["Zandalar Tribe"]..": Revered/Exalted";
    --Battlegrounds
    AtlasLoot_TableNames["AVMisc"][1] = "알터렉 계곡 ";
    AtlasLoot_TableNames["AVBlue"][1] = "알터렉 희귀 보상";
    AtlasLoot_TableNames["AVPurple"][1] = "알터렉 영웅 보상";
    AtlasLoot_TableNames["ABMisc"][1] = "아라시 분지 장신구류 보상";
    AtlasLoot_TableNames["ABSets1"][1] = "아라시 분지 방어구 세트 (천/가죽)";
    AtlasLoot_TableNames["ABSets2"][1] = "아라시 분지 방어구 세트 (사슬/판금)";
    AtlasLoot_TableNames["WSGMisc"][1] = "전쟁 노래 협곡 장신구류 보상";
    --World PvP
    AtlasLoot_TableNames["Hellfire"][1] = "지옥불 반도: 지옥불 성채";
    AtlasLoot_TableNames["Nagrand1"][1] = "나그란드: 할라아";
    AtlasLoot_TableNames["Nagrand2"][1] = "나그란드: 할라아";
    AtlasLoot_TableNames["Terokkar"][1] = "테로카르 숲: 영혼의 탑";
    AtlasLoot_TableNames["Zangarmarsh"][1] = "장가르 습지대: 쌍둥이 첨탑 폐허";
    --Misc Other PvP
    AtlasLoot_TableNames["PvP60Accessories1"][1] = "PvP 장신구류 (레벨 60)";
    AtlasLoot_TableNames["PvP60Accessories2"][1] = "PvP 장신구류 (레벨 60)";
    AtlasLoot_TableNames["PvP70Accessories1"][1] = "PvP 장신구류 (레벨 70)";
    AtlasLoot_TableNames["PvP70Accessories2"][1] = "PvP 장신구류 (레벨 70)";
    AtlasLoot_TableNames["PvP70NonSet1"][1] = "PvP Non-Set 영웅템: 장신구류";
    AtlasLoot_TableNames["PvP70NonSet2"][1] = "PvP Non-Set 영웅템: 천";
    AtlasLoot_TableNames["PvP70NonSet3"][1] = "PvP Non-Set 영웅템: 가죽";
    AtlasLoot_TableNames["PVPWeapons1"][1] = "레벨 60 PvP 무기";
    AtlasLoot_TableNames["PVPWeapons2"][1] = "레벨 60 PvP 무기";
    AtlasLoot_TableNames["PVP70Weapons1"][1] = "레벨 70 PvP 무기";
    AtlasLoot_TableNames["PVP70Weapons2"][1] = "레벨 70 PvP 무기";
    AtlasLoot_TableNames["Arena1Weapons1"][1] = "전장 시즌 1 무기";
    AtlasLoot_TableNames["Arena2Weapons1"][1] = "전장 시즌 2 무기";
    AtlasLoot_TableNames["Arena3Weapons1"][1] = "전장 시즌 3 무기";
    AtlasLoot_TableNames["Arena3Weapons2"][1] = "전장 시즌 3 무기";

end