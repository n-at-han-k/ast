{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1by7h2lwziiblizpd5yx87jsq8ppdhzvwf08ga34wzqgcv1nmpvz";
      type = "gem";
    };
    version = "2.9.0";
  };
  appraisal2 = {
    dependencies = ["rake" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fac3pbvk8ycij2ikrmm08i5rxa1m58dp07qm5ykwq2fcl3ghy6s";
      type = "gem";
    };
    version = "3.2.5";
  };
  ast = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10yknjyn0728gjn6b5syynvrvrwm66bhssbxq8mkhshxghaiailm";
      type = "gem";
    };
    version = "2.4.3";
  };
  ast-crispr = {
    dependencies = ["ast-merge" "service_actor" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z96xm8k8dwq7nprr60m198hic1yddanmikv3j70jjabjhwsscal";
      type = "gem";
    };
    version = "7.1.10";
  };
  ast-crispr-markdown-markly = {
    dependencies = ["ast-crispr" "markdown-merge" "markly-merge" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sy6cpd1dz00amn9y88r4jqgix938952wn4wycz8gdrygcfv9v90";
      type = "gem";
    };
    version = "7.1.10";
  };
  ast-crispr-ruby-prism = {
    dependencies = ["ast-crispr" "prism-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ypa8glpsf45zw8f758s7py0758b17m99y9jsbqijk3a37w880ny";
      type = "gem";
    };
    version = "7.1.10";
  };
  ast-merge = {
    dependencies = ["benchmark" "token-resolver" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16jcswigrhfgdvf3r5i80l31s06yc0c6qs0ccpffv6qnzkplh0x6";
      type = "gem";
    };
    version = "7.1.10";
  };
  ast-merge-git = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0669v3mqrg7c241gb0ipavfjd91lw2mqqdscp6vp6gk23nyhf3gf";
      type = "gem";
    };
    version = "7.1.10";
  };
  ast-template = {
    dependencies = ["ast-merge" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ny1widpgvfy1mm2p8qrpqqdqjf4rs8hqjynjjbjphyzf6h0qyab";
      type = "gem";
    };
    version = "7.1.10";
  };
  backports = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dbjl5ilyzlhl4p60pq41kdy4j8bg21f4m1vccawlh1wvhr8sacl";
      type = "gem";
    };
    version = "3.25.3";
  };
  bash-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b4hjjj6fy7lrlaqnyh5vlydbj0dr5w2chnvgpaps0lza52kg1jp";
      type = "gem";
    };
    version = "7.1.10";
  };
  benchmark = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v1337j39w1z7x9zs4q7ag0nfv4vs4xlsjx2la0wpv8s6hig2pa6";
      type = "gem";
    };
    version = "0.5.0";
  };
  binary-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jd5k4d47g9ajq8wsssifyppnp88i4l8sll8v06nyf3rjzr5zv93";
      type = "gem";
    };
    version = "7.1.10";
  };
  citrus = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l7nhk3gkm1hdchkzzhg2f70m47pc0afxfpl6mkiibc9qcpl3hjf";
      type = "gem";
    };
    version = "3.0.2";
  };
  citrus-toml-merge = {
    dependencies = ["ast-merge" "toml-merge" "toml-rb" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1as5k397mwq4nxvvfd5jyavk95w5ipash6k9dzq7fk8xhlfl3zqr";
      type = "gem";
    };
    version = "7.1.10";
  };
  commonmarker = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y4lhq7xd9gphp9plag7np42ddfys8zrpn8dxdkf1ph3lbg6gcgf";
      type = "gem";
    };
    version = "2.10.0";
  };
  commonmarker-merge = {
    dependencies = ["commonmarker" "markdown-merge" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yf4nx01hc7y9fpcvwxlvlxmpckvh2p1crly94l8r80cnxy2bx3y";
      type = "gem";
    };
    version = "7.1.10";
  };
  decode = {
    dependencies = ["prism" "rbs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0id8n5a020kpmdzjs6gvgpm1lj6i3maw1vpshw4vdw86s953crzm";
      type = "gem";
    };
    version = "0.30.0";
  };
  delegate = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01d8ksyj5bannbls9zh9i207wf9x9rb5h8csz6zkvv8bsa9i33q5";
      type = "gem";
    };
    version = "0.7.0";
  };
  diff-lcs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
  };
  dotenv-merge = {
    dependencies = ["ast-merge" "plain-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "087pkrbwy8yzby4lpdh2c660887zs9cg1m1qfxv8iyahmska21h0";
      type = "gem";
    };
    version = "7.1.10";
  };
  emoji_regex = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a9q95cqxryq7x9yadfk402r0302hmhckbp0cjaicqg5pv0b4255";
      type = "gem";
    };
    version = "15.0.0";
  };
  erb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14pfj6zn0p1hxj6s6s0r7d424wap8zl9zxf89nj79y8fbg16vjn5";
      type = "gem";
    };
    version = "6.0.7";
  };
  go-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h8m7i6ga0is1ymr0cmbyxm6ynpd36qpxmaa8l2pi1gx8z2g13wa";
      type = "gem";
    };
    version = "7.1.10";
  };
  html-merge = {
    dependencies = ["ast-crispr" "ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004nksxzqfs3ggiw7xslx53mqpv6qd6xl0kf83hmgj6pq1fbfw88";
      type = "gem";
    };
    version = "7.1.10";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1v9rhb19cnf1a89s6yvvhw394jy8qnqx9sg8bn12g5zpwcrrrw";
      type = "gem";
    };
    version = "3.1.0";
  };
  json-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x8s0sbs60fllf3qm0zh62xs09l17xvsy9rx9g6ngv8jjpgw43pr";
      type = "gem";
    };
    version = "7.1.10";
  };
  kettle-changelog = {
    dependencies = ["ast-crispr-markdown-markly" "kettle-dev" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "101630vmrn082gsb8jpk780ggi9xdqh42fi2pv0pc8wjvjf35jz3";
      type = "gem";
    };
    version = "1.0.10";
  };
  kettle-dev = {
    dependencies = ["emoji_regex" "kettle-gha-pins" "kettle-ndjson" "kettle-rb" "kettle-test" "ruby-progressbar" "tty-progressbar" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lki4d6dpm65bafz40acigxk77ymqqbqhhq33wigfdxc7bhd9pw2";
      type = "gem";
    };
    version = "3.1.13";
  };
  kettle-gha-pins = {
    dependencies = ["ruby-progressbar" "tty-progressbar" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0px6bnb02vfdzzw503wql7803xvpl1lnkf0f8d1j3isr0k07xjqr";
      type = "gem";
    };
    version = "0.3.17";
  };
  kettle-jem = {
    dependencies = ["addressable" "ast-crispr-markdown-markly" "ast-crispr-ruby-prism" "ast-merge" "bash-merge" "citrus-toml-merge" "dotenv-merge" "json-merge" "kettle-changelog" "kettle-dev" "kettle-gha-pins" "kettle-ndjson" "kettle-rb" "markdown-merge" "markly-merge" "parslet" "prism-merge" "psych-merge" "rbs" "rbs-merge" "ruby-merge" "token-resolver" "toml-merge" "toml-rb" "tree_haver" "version_gem" "yaml-merge"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "185n6c0gv807630agykkq2zgp0i9xzhh5psf8bqg9qcck2lwi61y";
      type = "gem";
    };
    version = "7.1.30";
  };
  kettle-ndjson = {
    dependencies = ["version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aqf55bkbq01as26jd3mb3varkwcs9gpwzm868xdg8j3kl2ndhvm";
      type = "gem";
    };
    version = "0.1.20";
  };
  kettle-rb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zvvkj3ri8fkjk73biad25avzcsbfn0m48fpn6akqiahmm0kdqkh";
      type = "gem";
    };
    version = "0.1.17";
  };
  kettle-test = {
    dependencies = ["appraisal2" "backports" "rspec" "rspec-block_is_expected" "rspec-pending_for" "rspec-stubbed_env" "rspec_junit_formatter" "silent_stream" "timecop-rspec" "turbo_tests2" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j7955r8a281xllpxz5lwz9z2gbmcija1jyvs73yay7kac1jp4ig";
      type = "gem";
    };
    version = "2.0.27";
  };
  kramdown = {
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yh2gwpwhh0p4vc0aabzn0hb55av0wkcq3gh3w8zkdk69hh4598v";
      type = "gem";
    };
    version = "2.5.2";
  };
  kramdown-merge = {
    dependencies = ["kramdown" "markdown-merge" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "084fpawg3j05fpp76g2axrq3ik993cfnkxh4kfyfg9bkwwxvmlrf";
      type = "gem";
    };
    version = "7.1.10";
  };
  language_server-protocol = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w5p8c2145lmqzr25bxh4ikzjm6k8y1k5lriqqdpw9pq730w1wjy";
      type = "gem";
    };
    version = "3.17.0.6";
  };
  lint_roller = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11yc0d84hsnlvx8cpk4cbj6a4dz9pk0r1k29p0n1fz9acddq831c";
      type = "gem";
    };
    version = "1.1.0";
  };
  logger = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  markdown-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lpqc1b10c5k98vq41f3ppvwalx5ggr44bqynf6x1j6cpnqqppr4";
      type = "gem";
    };
    version = "7.1.10";
  };
  markly = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jj4806xw0vx05f2jz4flzfimm4bgy3h8hd9lg90wrpkxa30wb6d";
      type = "gem";
    };
    version = "0.19.0";
  };
  markly-merge = {
    dependencies = ["markdown-merge" "markly" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02cplagi8rydp6l5qz3mhqsgfa0gi93kzpdnapslcd65smir8w8s";
      type = "gem";
    };
    version = "7.1.10";
  };
  nokogiri = {
    dependencies = ["racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qsqdvwdnykaja86ks2lwyb828j5dv5rpakg82hbr3d99jgns8j";
      type = "gem";
    };
    version = "1.19.4";
  };
  paco = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iqm0x0jd5hklfkv439zv3zh2zqdjvgx7iyk5qxm651f8b63ffrv";
      type = "gem";
    };
    version = "0.2.3";
  };
  parallel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vvs2sar7wnw70j1jc1kv1k23m5grc0ci3bbrcf6mkh18683wnpp";
      type = "gem";
    };
    version = "2.3.0";
  };
  parser = {
    dependencies = ["ast" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a4q5h2hcihk79dbr20scgkm56l79qp7fsvfvkxlv8nmapvxg9i1";
      type = "gem";
    };
    version = "3.3.12.0";
  };
  parslet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01pnw6ymz6nynklqvqxs4bcai25kcvnd5x4id9z3vd1rbmlk0lfl";
      type = "gem";
    };
    version = "2.0.0";
  };
  parslet-toml-merge = {
    dependencies = ["toml" "toml-merge" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jm7sbkf60r9kbkdslkzxy0iri22rgakga4qrh04y8f3mi4gzhri";
      type = "gem";
    };
    version = "7.1.10";
  };
  plain-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0prqc4q1rmpajq6kscdafz97fdqg956x92a453f5162iiacfgdk6";
      type = "gem";
    };
    version = "7.1.10";
  };
  prism = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11ggfikcs1lv17nhmhqyyp6z8nq5pkfcj6a904047hljkxm0qlvv";
      type = "gem";
    };
    version = "1.9.0";
  };
  prism-merge = {
    dependencies = ["ast-merge" "prism" "ruby-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15924p4zpzbax2iady19zlr708rknsz1zkhb5iky9s2s3rv85qvf";
      type = "gem";
    };
    version = "7.1.10";
  };
  psych-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem" "yaml-merge"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l1kgfs7hpl1wyjwiqaz1v3r47461y8wgwmhdily2d5y4asccqwz";
      type = "gem";
    };
    version = "7.1.10";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08znfv30pxmdkjyihvbjqbvv874dj3nybmmyscl958dy3f7v12qs";
      type = "gem";
    };
    version = "7.0.5";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rainbow = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "009p524zl0p0kfa65nii8wdmaigkmawv9pbvlcffky7islmmp0nb";
      type = "gem";
    };
    version = "13.4.2";
  };
  rbs = {
    dependencies = ["logger" "prism" "tsort"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x067q8cdam4kv5dc09iq2nzca8qm2kdl0dr22gc0ny0vj3bixsi";
      type = "gem";
    };
    version = "4.2.0";
  };
  rbs-merge = {
    dependencies = ["ast-merge" "rbs" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ly8d7p5xajlnbxcifw2mcgjcbjrcnq294mfc29rj7nw8f6l8x7z";
      type = "gem";
    };
    version = "7.1.10";
  };
  rdoc = {
    dependencies = ["erb" "prism" "rbs" "tsort"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02pn63i2r5z44hcfhxbaag9rvqsyznsliivnn7f3dzaw1a43gz5y";
      type = "gem";
    };
    version = "8.1.0";
  };
  regexp_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jxl6c5cagjz5i5n9jplhdy2izad6wapmwgfhqggb22nqfvvdvas";
      type = "gem";
    };
    version = "2.13.1";
  };
  require-hooks = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nci44lcba0lwga5nqi3vwrs035gazr4wr6h0s05n75r312v39j9";
      type = "gem";
    };
    version = "0.5.1";
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hninnbvqd2pn40h863lbrn9p11gvdxp928izkag5ysx8b1s5q0r";
      type = "gem";
    };
    version = "3.4.4";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-block_is_expected = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10j2yxpvmv875h9zdjxm58hnwzzkynzx2gyb9p7vx4xs1v1kvbdv";
      type = "gem";
    };
    version = "1.0.6";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    version = "3.13.5";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iqxmw0knjiz5nf6pgr8ihs6cjzh89f0ppj3fqiz8cvms79x6sh8";
      type = "gem";
    };
    version = "3.13.8";
  };
  rspec-pending_for = {
    dependencies = ["rspec-core" "ruby_engine" "ruby_version"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wzfm7z09qkqmjwy5y6p051vzrinslq8km21fkp9i0sj5gpsr6f4";
      type = "gem";
    };
    version = "0.1.28";
  };
  rspec-stubbed_env = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lnws0qzfkbq3viq2c81kjnsdzy08y0z1fb1wj6v0hmplqx62cbf";
      type = "gem";
    };
    version = "1.0.17";
  };
  rspec-support = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z64h5rznm2zv21vjdjshz4v0h7bxvg02yc6g7yzxakj11byah06";
      type = "gem";
    };
    version = "3.13.7";
  };
  rspec_junit_formatter = {
    dependencies = ["rspec-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "059bnq1gcwl9g93cqf13zpz38zk7jxaa43anzz06qkmfwrsfdpa0";
      type = "gem";
    };
    version = "0.6.0";
  };
  rubocop = {
    dependencies = ["json" "language_server-protocol" "lint_roller" "parallel" "parser" "rainbow" "regexp_parser" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q2nih91fjbv6j1qqxfhlc480zyhz94rniyh469vsw1fzd0q1xia";
      type = "gem";
    };
    version = "1.92.0";
  };
  rubocop-ast = {
    dependencies = ["parser" "prism"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nw84xk6vc2ls8sxqvyhxs2agh4l0jrws85d4bi3x0501lq8ijmr";
      type = "gem";
    };
    version = "1.50.0";
  };
  ruby-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09wfg0l696c5dc8x338gwn9in0mw6gk21pg8lyw7yxpvhssv3333";
      type = "gem";
    };
    version = "7.1.10";
  };
  ruby-next = {
    dependencies = ["paco" "require-hooks" "ruby-next-core" "ruby-next-parser" "unparser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11cxa8lrs5fajfkhd4gpj9rv84kn4mlbxf4iirqyg1bgsl89wq3f";
      type = "gem";
    };
    version = "1.2.1";
  };
  ruby-next-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y8zamhz6d4nkx4mwxhsi9rvrm7dpsyyig96k8ll6w8jdsc3xfnx";
      type = "gem";
    };
    version = "1.2.1";
  };
  ruby-next-parser = {
    dependencies = ["parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aa58g3qf6d4f44zmac5x5h3ffv8w52xd1b4r8q28wzmb6w55107";
      type = "gem";
    };
    version = "3.4.0.2";
  };
  ruby-progressbar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby_engine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ala4zx6gdq271n2bh2x4h1v9j2rbmnx71m1nszw5kfgz3gffana";
      type = "gem";
    };
    version = "2.0.3";
  };
  ruby_version = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dfcy4bz7kgmp4i7kvqg2w5l9rsf6vp9hhqqfg4ydds60yazjc2r";
      type = "gem";
    };
    version = "1.0.3";
  };
  runtime_groups = {
    dependencies = ["version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0babfqwc58l9zicvrhnvjpwxa7dy2mhm544py7aazajyc03qhq6r";
      type = "gem";
    };
    version = "0.1.3";
  };
  rust-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wsfxjp79a4nmk10n3xqscar22kxlc2s6qrxl626z72x73s26d0w";
      type = "gem";
    };
    version = "7.1.10";
  };
  service_actor = {
    dependencies = ["zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kirjmy89vw1n9bqa54wvssna9cdn09h3adjb4lyd9xr60v54fz6";
      type = "gem";
    };
    version = "3.9.4";
  };
  silent_stream = {
    dependencies = ["logger" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10p778ghkwsnzj75kpsn90f2v7ypjz6si7mk6c6fjgq322m46z1p";
      type = "gem";
    };
    version = "1.0.12";
  };
  smorg-rb = {
    dependencies = ["ast-merge" "ast-merge-git" "bash-merge" "diff-lcs" "dotenv-merge" "go-merge" "html-merge" "json-merge" "kettle-jem" "markdown-merge" "plain-merge" "prism-merge" "psych-merge" "rbs-merge" "rust-merge" "toml-merge" "typescript-merge" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02mr5x42dm7zs41vpy48s3fhi70mqxjn6561qf9b3alrdw2kkxns";
      type = "gem";
    };
    version = "7.1.10";
  };
  sorbet-runtime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11lkhcg7gz5hb4aamv8lg5lz3l4qm0g2nprjcpzj592n18bcq6y1";
      type = "gem";
    };
    version = "0.6.13558";
  };
  strings-ansi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "120wa6yjc63b84lprglc52f40hx3fx920n4dmv14rad41rv2s9lh";
      type = "gem";
    };
    version = "0.2.0";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wsy88vg2mazl039392hqrcwvs5nb9kq8jhhrrclir2px1gybag3";
      type = "gem";
    };
    version = "1.5.0";
  };
  timecop = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hkmrkg46qvfla31734d5y28q422z5kfgb41yy2227q4wp34sa21";
      type = "gem";
    };
    version = "0.9.11";
  };
  timecop-rspec = {
    dependencies = ["delegate" "rspec" "timecop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fgsk3jl16ls7a5ywavl6yaybql8acdk43h6zfpdq1mn3f218pq0";
      type = "gem";
    };
    version = "1.0.3";
  };
  token-resolver = {
    dependencies = ["parslet" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "199k1ql631p45m41kha950qxz6dxsxa9y7wrdqigfbz3dg791a5b";
      type = "gem";
    };
    version = "2.0.13";
  };
  toml = {
    dependencies = ["parslet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fg4qvn5c80z4ysy7j1svz0milsq5yqr6mpr8i7fhdlhdbvx148a";
      type = "gem";
    };
    version = "0.3.0";
  };
  toml-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0496rh4al3p8ly4zrawccc4zv7kh3hwkyv1pl74gs4gdnyw4f37k";
      type = "gem";
    };
    version = "7.1.10";
  };
  toml-rb = {
    dependencies = ["citrus" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02m6n2vryf04nzznvymww9js0jgy96mrfxh1f96biyms2xhz675l";
      type = "gem";
    };
    version = "4.2.2";
  };
  tree_haver = {
    dependencies = ["citrus" "parslet" "tree_sitter_language_pack" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vb95rdzjrza09d0skyj10m839a31fk06kibjprivklzf0fi5wj7";
      type = "gem";
    };
    version = "7.1.10";
  };
  tree_sitter_language_pack = {
    dependencies = ["sorbet-runtime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d6l02v4m94x2r0lh82n0q0g43xwr3gfslmq0i5rhwf61q63k41c";
      type = "gem";
    };
    version = "1.22.1";
  };
  tsort = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17q8h020dw73wjmql50lqw5ddsngg67jfw8ncjv476l5ys9sfl4n";
      type = "gem";
    };
    version = "0.2.0";
  };
  tty-cursor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-progressbar = {
    dependencies = ["strings-ansi" "tty-cursor" "tty-screen" "unicode-display_width"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xm5sk1sqp7v16akqpxza672qza6dbml68ah1lcajx2ywmh45fvc";
      type = "gem";
    };
    version = "0.18.3";
  };
  tty-screen = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l4vh6g333jxm9lakilkva2gn17j6gb052626r1pdbmy2lhnb460";
      type = "gem";
    };
    version = "0.8.2";
  };
  turbo_tests2 = {
    dependencies = ["rspec" "runtime_groups" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gdf57s19gwfrga8bymr493d7ykg6q8fv3yapi33k5yaxqljw750";
      type = "gem";
    };
    version = "4.0.0";
  };
  typescript-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02b4mjv3mknylgbddvrzkd0qz9935g625xdy5gpq1kcw69zzw81v";
      type = "gem";
    };
    version = "7.1.10";
  };
  unicode-display_width = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nkz7fadlrdbkf37m0x7sw8bnz8r355q3vwcfb9f9md6pds9h9qj";
      type = "gem";
    };
    version = "2.6.0";
  };
  unparser = {
    dependencies = ["diff-lcs" "parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rxdgilcs3mcwc29zjy3fhkldn19nhxff0nr14pi0zxdlr5rk7hm";
      type = "gem";
    };
    version = "0.6.15";
  };
  version_gem = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l17paljrcjdrvv0ida39msync07v3g1ij70cwsjw999gdc42cm7";
      type = "gem";
    };
    version = "1.1.15";
  };
  yaml-merge = {
    dependencies = ["ast-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01z3d6q3g136ypi4csdl4pa109c6p7cks3av2l1vjya4aq9350pf";
      type = "gem";
    };
    version = "7.1.10";
  };
  yard = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lfwngmsz3xq9k9la9890cqpm4vk3rda4171yzms7f3w7x4i3qjj";
      type = "gem";
    };
    version = "0.9.45";
  };
  zeitwerk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rcjpgyzmdxp8rdw466156fmr588k9q1wg8j42g0dkk7hid1519c";
      type = "gem";
    };
    version = "2.8.3";
  };
  zip-merge = {
    dependencies = ["binary-merge" "tree_haver" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lp7z15s57a96aiwddbpmj5wf5kh9y5jcik82bbgip6v8hhfawnq";
      type = "gem";
    };
    version = "7.1.10";
  };
}
