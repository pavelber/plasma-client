package vo
{
	import mx.collections.ArrayCollection;
	
	
	public class FileCatalog
	{
		public static const FAC_CATALOG:ArrayCollection = 
		new ArrayCollection
		(
			[
				{	
					name:"fac.lev",
					type:"Levels"
				},
				{	
					name:"fac.ce",
					type:"Excitation"
				},
				{	
					name:"fac.ci",
					type:"Ionization"
				},
				{	
					name:"fac.rr",
					type:"Photoionization"
				},
				{	
					name:"fac.ai",
					type:"Autoionization"
				},
				{	
					name:"fac.tr",
					type:"Radiative transitions"
				},
				{	
					name:"facosc.tr",
					type:"Fisher"
				}
			]
		);

		public static const FIT_CATALOG:ArrayCollection = 
		new ArrayCollection
		(
			[
				{	
					name:"EXCIT.INP",
					type:"Excitation"
				},
				{	
					name:"BCFP.INP",
					type:"Ionization"
				},
				{	
					name:"RREC.INP",
					type:"Photoionization"
				}
			]
		);
	}
}