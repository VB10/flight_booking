# typed: false
# frozen_string_literal: true

# Public tap + public source.
#
# Bu repo hem Homebrew tap'i hem de formula kaynagidir; senkron tutulacak ikinci
# bir repo yoktur. Paket derlenen bir sey icermez — .claude/skills ve docs/prompt
# iceriginin salt veri tasimacisidir.
class MasterflutterSkill < Formula
  desc "Claude Code skills from the Flutter Refactoring Masterclass"
  homepage "https://github.com/VB10/flight_booking"

  # Surum, tag ve commit Release workflow'u tarafindan otomatik guncellenir
  # (.github/workflows/release.yml → "Formula'yi yeni surume sabitle" adimi).
  # Tag'e ek olarak revision da pinlenir: tag surumu adlandirir, revision
  # degisiklige karsi kanit olur (git kaynakli formula'da sha256'nin karsiligi).
  url "https://github.com/VB10/flight_booking.git",
      using:    :git,
      tag:      "skills-v0.1.0",
      revision: "b7f3c685e55e9498789de790f360e542f600411c"
  # Tag 'skills-v' prefix'li oldugu icin surum acikca belirtilir.
  version "0.1.0"

  head "https://github.com/VB10/flight_booking.git", branch: "main"

  # Derlenecek bir sey yok → bottle yok, platforma ozel davranis yok. Kaynak
  # yerlesimi korunur ki bin/masterflutter-skill Cellar icinden de calisabilsin.
  def install
    pkgshare.install ".claude/skills"
    pkgshare.install "docs/prompt"
    pkgshare.install "README.md"

    # Homebrew kullanicinin home dizinine yazmamalidir; etkinlestirme bu yuzden
    # acik bir opt-in adimdir: `masterflutter-skill init`.
    bin.install "bin/masterflutter-skill"
    inreplace bin/"masterflutter-skill" do |s|
      s.gsub! "@@PKGSHARE@@", opt_pkgshare
      s.gsub! "@@VERSION@@", version
    end
  end

  def caveats
    <<~EOS
      Home dizinine henuz hicbir sey yazilmadi.

      Skill'leri Claude Code icin etkinlestirmek icin
      (~/.claude/skills altina kopyalar, her projede gecerli):

        masterflutter-skill init

      Ardindan Claude Code'u yeniden baslat.

      Skill'ler aksiyondan once docs/prompt/*.md spesifikasyonlarini
      proje-goreli yoldan okur. Her Flutter projesinde bir kez:

        cd <proje> && masterflutter-skill project

      Diger komutlar:

        masterflutter-skill status   global + proje durumu, bayat kopyayi isaretler
        masterflutter-skill remove   kopyalanan masterflutter-* dosyalarini siler

      `brew upgrade masterflutter-skill` sonrasi `masterflutter-skill init`
      (ve proje basina `masterflutter-skill project`) tekrar calistirilmalidir.
    EOS
  end

  test do
    # Etkinlestirme komutu kendi payload yolunu cozer ve gercek ~/.claude'a
    # dokunmaz: CLAUDE_CONFIG_DIR onu test kumuna yonlendirir.
    ENV["CLAUDE_CONFIG_DIR"] = testpath/"claude"
    assert_match "masterflutter-skill", shell_output("#{bin}/masterflutter-skill --help")

    system bin/"masterflutter-skill", "init"
    installed = (testpath/"claude/skills").children.select do |child|
      child.directory? && child.basename.to_s.start_with?("masterflutter-")
    end
    refute_empty installed, "no skills were installed"
    assert_equal version.to_s, (testpath/"claude/skills/.masterflutter-version").read.strip
    assert_path_exists testpath/"claude/reference/masterflutter/prompt"

    # Proje kurulumu: SKILL.md icindeki ../../../docs/prompt yollari cozulur.
    (testpath/"proj").mkpath
    system bin/"masterflutter-skill", "project", testpath/"proj"
    assert_path_exists testpath/"proj/.claude/skills"
    assert_path_exists testpath/"proj/docs/prompt/flutter_cubit_feature_prompt.md"

    system bin/"masterflutter-skill", "remove"
    refute_path_exists testpath/"claude/skills/.masterflutter-version"

    # Payload Homebrew'un yonettigi prefix'e indi.
    assert_path_exists pkgshare/"skills"
    assert_path_exists pkgshare/"prompt/flutter_cubit_feature_prompt.md"

    # Paketlenen her skill dizini bos olmayan bir SKILL.md tasir.
    skill_dirs = (pkgshare/"skills").children.select(&:directory?)
    refute_empty skill_dirs, "no skills were packaged"
    skill_dirs.each do |dir|
      manifest = dir/"SKILL.md"
      assert_path_exists manifest
      refute_empty manifest.read.strip, "#{manifest} is empty"
    end
  end
end
