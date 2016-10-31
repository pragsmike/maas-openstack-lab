(set-env!
 :source-paths #{"src"}
 :resource-paths #{"tmp"}
 :dependencies '[[org.clojure/clojure "1.8.0" :scope "provided"]
                 [org.clojure/data.json "0.2.6"]])

(require
 '[soup.main      :refer [main]]
)

(deftask run [] (main :all))
