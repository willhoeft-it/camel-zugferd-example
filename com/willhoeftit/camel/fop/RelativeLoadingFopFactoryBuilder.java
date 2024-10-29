
package com.willhoeftit.camel.fop;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;
import java.net.URI;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.FopFactoryBuilder;
import org.apache.fop.apps.io.ResourceResolverFactory;
import org.apache.fop.configuration.DefaultConfiguration;
import org.apache.fop.configuration.DefaultConfigurationBuilder;
import org.apache.xmlgraphics.io.Resource;
import org.apache.xmlgraphics.io.ResourceResolver;

/**
 * A builder to create a FopFactory that allows to relative path references in the fopconfig.xml file. Otherwise FOP will only load absolute file references.
 * 
 * TODO: Classpath references do not seem to work for Camel JBang. It seems as if this bean uses a different class loader which does not "see" the other files?
 *       We just skip the classpath approach, and just load from file, passing the base directory as parameter
 * 
 * Idea is taken from https://stackoverflow.com/questions/17745133/load-a-font-from-jar-for-fop , then refactored and modified to be used with Apache Camel JBang.
 */
public class RelativeLoadingFopFactoryBuilder {

    private static class ClasspathResourceResolver implements ResourceResolver {

        @Override
        public Resource getResource(final URI uri) throws IOException {
            final String uriString = uri.toString();
            // System.out.println("uriString: " + uriString);
            if(uriString.startsWith("classpath:/")) {
                // TODO: in Apache Camel JBang context resources do not seem to be available for this bean's ClassLoader. So this is unused and untested.
                // System.out.println("Reading from classpath: " + uriString.substring(10));
                final InputStream resourceAsStream = Thread.currentThread().getContextClassLoader().getResourceAsStream(uriString.substring(10));
                return (new Resource(resourceAsStream));
            } else if(uriString.startsWith("file:")) {
                final File resFile = new File(uriString.substring(5));
                // System.out.println("Reading from file: " + resFile.getAbsolutePath());
                final InputStream resourceAsStream = new FileInputStream(resFile);
                return(new Resource(resourceAsStream));
            } else {
                return new Resource(Thread.currentThread().getContextClassLoader().getResourceAsStream(uriString));
            }
        }
    
        @Override
        public OutputStream getOutputStream(final URI uri) throws IOException {
            return new FileOutputStream(new File(uri));
        }
    }

    public static class RelativeLoadingFopFactoryBuildFailure extends RuntimeException {
        public RelativeLoadingFopFactoryBuildFailure(final Exception cause) {
            super(cause);
        }
    }

    public static FopFactory createFopFactory(final String fopConfigPath) throws RelativeLoadingFopFactoryBuildFailure {
        try {
            final URI defaultBaseUri = new File(fopConfigPath).getParentFile().toURI();
            final DefaultConfigurationBuilder cfgBuilder = new DefaultConfigurationBuilder();
            // System.out.println("fopConfigPath: " + fopConfigPath); 
            // final DefaultConfiguration cfg = cfgBuilder.build(ClasspathLoadingFopFactoryBuilder.class.getResourceAsStream(fopConfigPath));
            final DefaultConfiguration cfg = cfgBuilder.buildFromFile(new File(fopConfigPath));

            // this will allow you to reference external graphics from within a jar file
            // TODO: check / update this for graphics and file:
            // i.e. <fo:external-graphic src="classpath:///images/puppy.jpg" content-width="7.02cm" />
            final FopFactoryBuilder fopFactoryBuilder = new FopFactoryBuilder(
                    defaultBaseUri,
                    new ClasspathResourceResolver())
                    .setConfiguration(cfg);

            final FopFactory fopFactory = fopFactoryBuilder.build();

            // This will allow you to load fonts relative to the fopconfig.xml i.e.
            // <font kerning="yes" embed-url="file:../fonts/Poppins-LightItalic.ttf" embedding-mode="subset">
            fopFactory.getFontManager().setResourceResolver(
                    ResourceResolverFactory.createInternalResourceResolver(
                        defaultBaseUri,
                            new ClasspathResourceResolver()));
            return fopFactory;
        } catch (final Exception e) {
            throw new RelativeLoadingFopFactoryBuildFailure(e);
        }
    }
}